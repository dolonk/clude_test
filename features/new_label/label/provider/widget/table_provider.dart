import 'dart:async';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:grozziie/localization/main_texts.dart';
import '../../../../../common/clipboard_service/clipboard_service.dart';
import '../common/common_function_provider.dart';
import '../../../../../common/font_load/font_load.dart';
import '../../../../../utils/local_storage/local_data.dart';
import '../../../../../utils/snackbar_toast/snack_bar.dart';
import '../../../../../utils/extension/global_context.dart';
import '../../../../../common/redo_undo/undo_redo_manager.dart';
import '../../../../../common/font_load/font_family_model.dart';
import '../../../../../utils/constants/label_global_variable.dart';
import 'package:grozziie/utils/extension/provider_extension.dart';
import '../../../../../data_layer/models/redo_undo_model/table_state.dart';
import 'package:grozziie/utils/extension/null_check_extension.dart';
import '../../view/dashboard_option/templated_container/show_widget_class/table_widget_class.dart';

class TableProvider extends ChangeNotifier {
  final CommonFunctionProvider commonModel = CommonFunctionProvider();

  int _pasteCount = 0;
  Timer? _debounce;

  void setShowTableWidget(bool flag) {
    showTableWidget = flag;
    saveCurrentTableState();
    notifyListeners();
  }

  /// ======================== UTILS ====================
  bool checkSelectCell() {
    if (!_hasValidTable || tablesSelectedCells[selectedTableIndex].isEmpty) {
      final context = GlobalContext.context;
      if (context == null) return false;
      DSnackBar.informationSnackBar(title: DTexts.instance.selectCell);
      return false;
    }
    return true;
  }

  bool get _hasValidTable =>
      selectedTableIndex >= 0 &&
      selectedTableIndex < tablesCells.length &&
      selectedTableIndex < tablesRowHeights.length &&
      selectedTableIndex < tablesColumnWidths.length;

  GridCell? getSelectedCell() {
    if (!_hasValidTable) return null;

    final cells = tablesCells[selectedTableIndex];
    if (cells.isEmpty) return null;

    return cells.firstWhereOrNull((c) => c.rowIndex == selectedRowIndex && c.colIndex == selectedColIndex);
  }

  GridCell? getCurrentCell(int tableIndex, int row, int col) {
    if (tableIndex < 0 || tableIndex >= tablesCells.length || tablesCells[tableIndex].isEmpty) return null;
    return tablesCells[tableIndex].firstWhereOrNull((c) => c.rowIndex == row && c.colIndex == col);
  }

  /// =================== UNDO / REDO ====================
  void saveCurrentTableState() {
    final context = GlobalContext.context;
    if (context == null) return;

    final snapshot = TableState.snapshot(
      inputText: inputText,
      tableCodes: tableCodes,
      tableOffsets: tableOffsets,
      rowCount: rowCount,
      columnCount: columnCount,
      tableLineWidth: tableLineWidth,
      tablesCells: tablesCells,
      tablesRowHeights: tablesRowHeights,
      tablesColumnWidths: tablesColumnWidths,
      tablesSelectedCells: tablesSelectedCells,
      tableBorderStyle: tableBorderStyle,
      isTableLock: isTableLock,
      tableBorder: tableBorder,
      showTableWidget: showTableWidget,
      showTableContainerFlag: showTableContainerFlag,
      selectedColIndex: selectedColIndex,
      selectedRowIndex: selectedRowIndex,
      selectedTableIndex: selectedTableIndex,
      tableContainerRotations: tableContainerRotations,
    );

    context.undoRedoProvider.addAction(
      ActionState(type: "Table", state: snapshot, restore: (s) => _restoreTableState(s as TableState)),
    );
  }

  void _restoreTableState(TableState s) {
    inputText = s.inputText;
    tableCodes = List.from(s.tableCodes);
    tableOffsets = List.from(s.tableOffsets);
    rowCount = List.from(s.rowCount);
    columnCount = List.from(s.columnCount);
    tableLineWidth = List.from(s.tableLineWidth);
    tablesRowHeights = TableState.deepCopyNestedList(s.tablesRowHeights);
    tablesColumnWidths = TableState.deepCopyNestedList(s.tablesColumnWidths);
    tablesCells = TableState.deepCopyTablesCells(s.tablesCells);
    tablesSelectedCells = TableState.deepCopyTablesCells(s.tablesSelectedCells);
    tableBorderStyle = List.from(s.tableBorderStyle);
    isTableLock = List.from(s.isTableLock);

    tableBorder = s.tableBorder;
    showTableWidget = s.showTableWidget;
    showTableContainerFlag = s.showTableContainerFlag;
    selectedColIndex = s.selectedColIndex;
    selectedRowIndex = s.selectedRowIndex;
    selectedTableIndex = s.selectedTableIndex;
    tableContainerRotations = List.from(s.tableContainerRotations);

    notifyListeners();
  }

  /// ==================== COPY / PASTE ====================
  Future<void> copyTableWidget() async {
    final context = GlobalContext.context;
    if (context == null) return;
    _pasteCount = 0;

    final snapshot = TableState.snapshot(
      inputText: inputText,
      tableCodes: [tableCodes[selectedTableIndex]],
      tableOffsets: [tableOffsets[selectedTableIndex]],
      rowCount: [rowCount[selectedTableIndex]],
      columnCount: [columnCount[selectedTableIndex]],
      tableLineWidth: [tableLineWidth[selectedTableIndex]],
      tablesCells: [tablesCells[selectedTableIndex]],
      tablesRowHeights: [List.from(tablesRowHeights[selectedTableIndex])],
      tablesColumnWidths: [List.from(tablesColumnWidths[selectedTableIndex])],
      tablesSelectedCells: [tablesSelectedCells[selectedTableIndex]],
      isTableLock: [isTableLock[selectedTableIndex]],

      tableBorder: tableBorder,
      showTableWidget: true,
      showTableContainerFlag: true,
      selectedColIndex: 0,
      selectedRowIndex: 0,
      selectedTableIndex: 0,
      tableContainerRotations: [tableContainerRotations[selectedTableIndex]],
      tableBorderStyle: [tableBorderStyle[selectedTableIndex]],
    );

    context.copyPasteProvider.copy(ClipboardItem(type: "table", state: snapshot));
  }

  Future<void> pasteTableWidget(ClipboardItem clipboard) async {
    commonModel.clearAllBorder();
    final context = GlobalContext.context;
    if (context == null) return;

    if (clipboard.state is! TableState) return;
    final pastedState = clipboard.state as TableState;

    _pasteCount++;
    Offset shift = Offset(10.0 * _pasteCount, 50.0 * _pasteCount);

    tableCodes.addAll(pastedState.tableCodes);
    tableOffsets.addAll(pastedState.tableOffsets.map((offset) => offset + shift));
    rowCount.addAll(pastedState.rowCount);
    columnCount.addAll(pastedState.columnCount);
    tableLineWidth.addAll(pastedState.tableLineWidth);
    tablesRowHeights.addAll(TableState.deepCopyNestedList(pastedState.tablesRowHeights));
    tablesColumnWidths.addAll(TableState.deepCopyNestedList(pastedState.tablesColumnWidths));
    tablesCells.addAll(TableState.deepCopyTablesCells(pastedState.tablesCells));
    tablesSelectedCells.addAll(TableState.deepCopyTablesCells(pastedState.tablesSelectedCells));
    tableContainerRotations.addAll(pastedState.tableContainerRotations);
    tableBorderStyle.addAll(pastedState.tableBorderStyle);
    tableTextFocusNodes.add(FocusNode());
    textController.add(TextEditingController());
    isTableLock.add(false);

    inputText = pastedState.inputText;
    showTableWidget = pastedState.showTableWidget;
    showTableContainerFlag = pastedState.showTableContainerFlag;
    tableBorder = true;
    selectedTableIndex = tableCodes.length - 1;

    saveCurrentTableState();
    notifyListeners();
  }

  /// ==================== TABLE GENERATION & DELETE ====================
  Future<void> generateTable({int initialRows = 2, int initialCols = 2}) async {
    commonModel.generateBorderOff('table', true);
    tableCodes.add('Table');
    tableOffsets.add(Offset(0, tableCodes.length * 5.0));
    tableLineWidth.add(0.2);
    tableContainerRotations.add(0.0);
    tablesColumnWidths.add(List.generate(initialCols, (_) => 100.0));
    tablesRowHeights.add(List.generate(initialRows, (_) => 50.0));
    tablesSelectedCells.add([]);
    selectedTableIndex = tableCodes.length - 1;
    rowCount.add(initialRows);
    columnCount.add(initialCols);

    await _initializeCells(initialRows, initialCols);
    tableTextFocusNodes.add(FocusNode());
    textController.add(TextEditingController());
    tableBorderStyle.add(false);
    isTableLock.add(false);

    saveCurrentTableState();
    notifyListeners();
  }

  Future<void> _initializeCells(int rows, int cols) async {
    final fontKey = await LocalData.getLocalData<String>("FontFamily") ?? "SIMSUN";

    final cells = List.generate(rows, (r) {
      return List.generate(cols, (c) {
        return GridCell(
          text: '',
          rowIndex: r,
          colIndex: c,
          alignment: Alignment.center,
          textAlign: TextAlign.center,
          fontFamily: fontKey,
        );
      });
    }).expand((e) => e).toList();

    tablesCells.add(cells);
  }

  void deleteTable(int tableIndex) {
    if (tableIndex < 0 || tableIndex >= tableCodes.length) return;

    commonModel.generateBorderOff('table', false);

    // Remove main table lists
    tableCodes.removeAt(tableIndex);
    tableOffsets.removeAt(tableIndex);
    tableLineWidth.removeAt(tableIndex);

    tablesCells.removeAtOrNull(tableIndex);
    tablesSelectedCells.removeAtOrNull(tableIndex);
    tablesColumnWidths.removeAtOrNull(tableIndex);
    tablesRowHeights.removeAtOrNull(tableIndex);
    tableTextFocusNodes.removeAtOrNull(tableIndex);
    textController.removeAtOrNull(tableIndex);
    rowCount.removeAtOrNull(tableIndex);
    columnCount.removeAtOrNull(tableIndex);
    tableBorderStyle.removeAtOrNull(tableIndex);
    tableContainerRotations.removeAtOrNull(tableIndex);
    isTableLock.removeAtOrNull(tableIndex);

    if (tableCodes.isEmpty) {
      selectedTableIndex = -1;
    } else if (tableIndex <= selectedTableIndex) {
      selectedTableIndex = (selectedTableIndex - 1).clamp(0, tableCodes.length - 1);
    }

    saveCurrentTableState();
    notifyListeners();
  }

  /// ==================== RESIZE TABLE WIDTH & HEIGHT ====================
  void handleResizeGesture(DragUpdateDetails details, int tableIdx) {
    if (!_hasValidTable) return;

    final colCount = tablesColumnWidths[tableIdx].length;
    final rowCount = tablesRowHeights[tableIdx].length;
    final dx = details.delta.dx / colCount;
    final dy = details.delta.dy / rowCount;

    for (int i = 0; i < colCount; i++) {
      tablesColumnWidths[tableIdx][i] = (tablesColumnWidths[tableIdx][i] + dx).clamp(5, double.infinity);
    }
    for (int i = 0; i < rowCount; i++) {
      tablesRowHeights[tableIdx][i] = (tablesRowHeights[tableIdx][i] + dy).clamp(5, double.infinity);
    }

    notifyListeners();
  }

  /// ==================== TABLE CELL SELECTION ====================
  void onCellTap(int row, int col, int tableIdx) {
    // clear other tables
    _clearOtherTablesSelection(tableIdx);

    // clear all cells in this table
    for (var cell in tablesCells[tableIdx]) {
      cell.isTapped = false;
      cell.isLongPressed = false;
    }

    // now mark the tapped cell
    var cell = tablesCells[tableIdx].firstWhere((c) => c.rowIndex == row && c.colIndex == col);
    if (tableBorder) cell.isTapped = true;

    // update selected cells list
    tablesSelectedCells[tableIdx] = [cell];

    // update input text and focus
    selectedTextIndex = tableIdx;
    inputText = cell.text;
    textController[tableIdx].text = inputText;
    tableTextFocusNodes[tableIdx].requestFocus();

    saveCurrentTableState();
    notifyListeners();
  }

  void onCellLongPress(int row, int col, int tableIdx) {
    if (selectedTextIndex != tableIdx && selectedTextIndex >= 0) {
      _clearTableSelection(selectedTextIndex);
    }

    final cell = tablesCells[tableIdx].firstWhere((c) => c.rowIndex == row && c.colIndex == col);

    if (tablesSelectedCells[tableIdx].isNotEmpty) {
      var first = tablesSelectedCells[tableIdx].first;
      final minRow = first.rowIndex < row ? first.rowIndex : row;
      final maxRow = first.rowIndex > row ? first.rowIndex : row;
      final minCol = first.colIndex < col ? first.colIndex : col;
      final maxCol = first.colIndex > col ? first.colIndex : col;

      _clearTableSelection(tableIdx);

      for (var c in tablesCells[tableIdx]) {
        if (c.rowIndex >= minRow && c.rowIndex <= maxRow && c.colIndex >= minCol && c.colIndex <= maxCol) {
          c.isLongPressed = true;
          tablesSelectedCells[tableIdx].add(c);
        }
      }
    } else {
      cell.isLongPressed = !cell.isLongPressed;
      if (cell.isLongPressed) {
        tablesSelectedCells[tableIdx].add(cell);
      } else {
        tablesSelectedCells[tableIdx].remove(cell);
      }
    }

    selectedTextIndex = tableIdx;

    saveCurrentTableState();
    notifyListeners();
  }

  void _clearOtherTablesSelection(int exceptTable) {
    for (int i = 0; i < tablesCells.length; i++) {
      if (i != exceptTable) _clearTableSelection(i);
    }
  }

  void _clearTableSelection(int tableIdx) {
    for (var cell in tablesCells[tableIdx]) {
      cell.isTapped = false;
      cell.isLongPressed = false;
    }
    tablesSelectedCells[tableIdx].clear();
  }

  /// ==================== TABLE CELL ADD, REMOVE ====================
  bool canInsertRowAt(int insertRowIndex, TableAction action) {
    if (!checkSelectCell() || selectedTableIndex == -1) return false;
    final cells = tablesCells[selectedTableIndex];

    for (var cell in cells) {
      if (cell.rowSpan > 1) {
        // This is a merged cell
        int mergeStartRow = cell.rowIndex;
        int mergeEndRow = cell.rowIndex + cell.rowSpan - 1;

        if (insertRowIndex > mergeStartRow && insertRowIndex <= mergeEndRow) {
          if (action == TableAction.rowTop) {
            if (selectedRowIndex != mergeStartRow) {
              return false;
            }
          } else if (action == TableAction.rowBottom) {
            if (selectedRowIndex != mergeEndRow) {
              return false;
            }
          }
        }
      }
    }

    return true;
  }

  bool canInsertColAt(int insertColIndex, TableAction action) {
    if (!checkSelectCell() || selectedTableIndex == -1) return false;
    final cells = tablesCells[selectedTableIndex];

    for (var cell in cells) {
      if (cell.colSpan > 1) {
        int mergeStartCol = cell.colIndex;
        int mergeEndCol = cell.colIndex + cell.colSpan - 1;

        if (insertColIndex > mergeStartCol && insertColIndex <= mergeEndCol) {
          return false;
        }
      }
    }

    return true;
  }

  Future<void> addTableCell({required TableAction action, int count = 1}) async {
    if (!checkSelectCell()) return;
    if (tablesCells.isEmpty || selectedTableIndex == -1) return;

    final tableIndex = selectedTableIndex;
    final cells = tablesCells[tableIndex];
    final selectedCells = tablesSelectedCells[tableIndex];
    if (selectedCells.isEmpty) return;

    final double defaultFontSize = selectPrinter == "SDot" ? 15 : 6;
    final fontKey = await LocalData.getLocalData<String>("FontFamily") ?? "SIMSUN";

    // Freeze selection bounds once
    final origMinRow = selectedCells.map((c) => c.rowIndex).reduce((a, b) => a < b ? a : b);
    final origMaxRow = selectedCells.map((c) => c.rowIndex + c.rowSpan - 1).reduce((a, b) => a > b ? a : b);
    final origMinCol = selectedCells.map((c) => c.colIndex).reduce((a, b) => a < b ? a : b);
    final origMaxCol = selectedCells.map((c) => c.colIndex + c.colSpan - 1).reduce((a, b) => a > b ? a : b);

    int currentRowCount = tablesRowHeights[tableIndex].length;
    int currentColCount = tablesColumnWidths[tableIndex].length;

    for (int k = 0; k < count; k++) {
      if (action.isRow) {
        int insertRowIndex = action == TableAction.rowTop ? origMinRow : origMaxRow + 1 + k;

        if (!canInsertRowAt(insertRowIndex, action)) {
          final context = GlobalContext.context;
          if (context == null) return;
          DSnackBar.informationSnackBar(title: DTexts.instance.addRowWaring);
          return;
        }

        // Build new row
        List<GridCell> newRowCells = List.generate(
          currentColCount,
          (colIdx) => GridCell(
            text: '',
            rowIndex: insertRowIndex,
            colIndex: colIdx,
            fontFamily: fontKey,
            fontSize: defaultFontSize,
          ),
        );

        // Insert row in proper place
        int insertPos = cells.indexWhere((c) => c.rowIndex >= insertRowIndex);
        if (insertPos == -1) insertPos = cells.length;
        cells.insertAll(insertPos, newRowCells);

        // Shift below rows (always, top & bottom both)
        for (var cell in cells) {
          if (!newRowCells.contains(cell) && cell.rowIndex >= insertRowIndex) {
            cell.rowIndex += 1;
          }
        }

        double newRowHeight = 50.0;
        if (tablesRowHeights.isNotEmpty &&
            tablesRowHeights[tableIndex].isNotEmpty &&
            origMinRow < tablesRowHeights[tableIndex].length) {
          newRowHeight = tablesRowHeights[tableIndex][origMinRow];
        }

        tablesRowHeights[tableIndex].insert(insertRowIndex, newRowHeight);
        currentRowCount++;
      } else if (action.isColumn) {
        int insertColIndex = action == TableAction.colLeft ? origMinCol : origMaxCol + 1 + k;

        if (!canInsertColAt(insertColIndex, action)) {
          final context = GlobalContext.context;
          if (context == null) return;
          DSnackBar.informationSnackBar(title: DTexts.instance.addColumnWaring);
          return;
        }

        // shift all existing cells that will be affected
        for (var cell in cells) {
          if (cell.colIndex >= insertColIndex) {
            cell.colIndex += 1;
          }
        }

        // Create and add new column cells
        List<GridCell> newColumnCells = [];
        for (int row = 0; row < currentRowCount; row++) {
          newColumnCells.add(
            GridCell(text: '', rowIndex: row, colIndex: insertColIndex, fontFamily: fontKey, fontSize: defaultFontSize),
          );
        }

        // Insert new cells in proper positions
        for (var newCell in newColumnCells) {
          int insertPos = cells.indexWhere((c) => c.rowIndex == newCell.rowIndex && c.colIndex > newCell.colIndex);
          if (insertPos == -1) {
            insertPos = cells.lastIndexWhere((c) => c.rowIndex == newCell.rowIndex) + 1;
            if (insertPos == 0) insertPos = cells.length;
          }
          cells.insert(insertPos, newCell);
        }

        double newColWidth = 100.0;
        if (tablesColumnWidths.isNotEmpty &&
            tablesColumnWidths[tableIndex].isNotEmpty &&
            origMinCol < tablesColumnWidths[tableIndex].length) {
          newColWidth = tablesColumnWidths[tableIndex][origMinCol];
        }

        tablesColumnWidths[tableIndex].insert(insertColIndex, newColWidth);
        currentColCount++;
      }
    }

    // Update meta
    rowCount[tableIndex] = currentRowCount;
    columnCount[tableIndex] = currentColCount;

    // Keep selection stable
    switch (action) {
      case TableAction.rowTop:
        selectedRowIndex = origMinRow + count;
        selectedColIndex = origMinCol;
        break;
      case TableAction.rowBottom:
        selectedRowIndex = origMaxRow + 1;
        selectedColIndex = origMinCol;
        break;
      case TableAction.colLeft:
        selectedColIndex = origMinCol + count;
        selectedRowIndex = origMinRow;
        break;
      case TableAction.colRight:
        selectedColIndex = origMaxCol + 1;
        selectedRowIndex = origMinRow;
        break;
    }

    saveCurrentTableState();
    notifyListeners();
  }

  bool canDeleteRows(List<int> rowsToDelete) {
    if (!checkSelectCell() || selectedTableIndex == -1) return false;
    final cells = tablesCells[selectedTableIndex];

    // Check all vertical merged cells
    for (var cell in cells) {
      if (cell.rowSpan > 1) {
        int mergeStartRow = cell.rowIndex;
        int mergeEndRow = cell.rowIndex + cell.rowSpan - 1;

        for (int rowToDelete in rowsToDelete) {
          if (rowToDelete >= mergeStartRow && rowToDelete <= mergeEndRow) {
            return false;
          }
        }
      }
    }

    return true;
  }

  void deleteSelectedRows() {
    if (!checkSelectCell()) return;

    if (tablesSelectedCells[selectedTableIndex].isNotEmpty && rowCount[selectedTableIndex] > 1) {
      final selectedRowIndexes = tablesSelectedCells[selectedTableIndex].map((c) => c.rowIndex).toSet().toList()
        ..sort();

      if (selectedRowIndexes.length == rowCount[selectedTableIndex]) return;

      if (!canDeleteRows(selectedRowIndexes)) {
        final context = GlobalContext.context;
        if (context == null) return;
        DSnackBar.informationSnackBar(title: DTexts.instance.deleteRowWaring);
        return;
      }

      // row delete section
      for (var rowIndex in selectedRowIndexes.reversed) {
        tablesCells[selectedTableIndex].removeWhere((cell) => cell.rowIndex == rowIndex);

        if (rowIndex < tablesRowHeights[selectedTableIndex].length) {
          tablesRowHeights[selectedTableIndex].removeAt(rowIndex);
        }

        for (var cell in tablesCells[selectedTableIndex]) {
          if (cell.rowIndex > rowIndex) {
            cell.rowIndex -= 1;
          }
        }

        // update row count
        rowCount[selectedTableIndex] -= 1;
      }

      // clear selection
      tablesSelectedCells[selectedTableIndex].clear();
      saveCurrentTableState();
      notifyListeners();
    }
  }

  bool canDeleteColumns(List<int> colsToDelete) {
    if (!checkSelectCell() || selectedTableIndex == -1) return false;

    final cells = tablesCells[selectedTableIndex];

    // Check all horizontal merged cells
    for (var cell in cells) {
      if (cell.colSpan > 1) {
        int mergeStartCol = cell.colIndex;
        int mergeEndCol = cell.colIndex + cell.colSpan - 1;

        for (int colToDelete in colsToDelete) {
          if (colToDelete >= mergeStartCol && colToDelete <= mergeEndCol) {
            return false;
          }
        }
      }
    }

    return true;
  }

  void deleteSelectedColumns() {
    if (!checkSelectCell()) return;

    final selectedCells = tablesSelectedCells[selectedTableIndex];
    if (selectedCells.isEmpty || columnCount[selectedTableIndex] <= 1) return;

    // Get unique selected column indexes
    final selectedColIndexes = selectedCells.map((c) => c.colIndex).toSet().toList()..sort((a, b) => b.compareTo(a));

    if (!canDeleteColumns(selectedColIndexes)) {
      final context = GlobalContext.context;
      if (context == null) return;
      DSnackBar.informationSnackBar(title: DTexts.instance.deleteColumnWaring);
      return;
    }

    // column delete section
    for (var selectedColIndex in selectedColIndexes) {
      if (columnCount[selectedTableIndex] <= 1) break;

      // Adjust colSpan for merged cells spanning deleted column
      for (var cell in tablesCells[selectedTableIndex]) {
        if (cell.colIndex < selectedColIndex && cell.colIndex + cell.colSpan > selectedColIndex) {
          cell.colSpan -= 1;
        }
      }

      // Remove cells in that column
      tablesCells[selectedTableIndex].removeWhere((cell) => cell.colIndex == selectedColIndex);

      // Shift columns after deleted column
      for (var cell in tablesCells[selectedTableIndex]) {
        if (cell.colIndex > selectedColIndex) {
          cell.colIndex -= 1;
        }
      }

      // Remove column width entry
      if (selectedColIndex < tablesColumnWidths[selectedTableIndex].length) {
        tablesColumnWidths[selectedTableIndex].removeAt(selectedColIndex);
      }

      columnCount[selectedTableIndex] = tablesColumnWidths[selectedTableIndex].length;
    }

    // Clear selection
    tablesSelectedCells[selectedTableIndex].clear();
    saveCurrentTableState();
    notifyListeners();
  }

  /// ==================== TABLE CELL SELECTION , MERGE, SPLIT ====================
  void adjustSelectedRowHeight(double newHeight) {
    if (tablesSelectedCells[selectedTableIndex].isNotEmpty) {
      List<double> newRowHeights = List.from(tablesRowHeights[selectedTableIndex]);
      bool heightsChanged = false;

      for (var cell in tablesSelectedCells[selectedTableIndex]) {
        if (newRowHeights[cell.rowIndex] != newHeight) {
          newRowHeights[cell.rowIndex] = newHeight;
          heightsChanged = true;
        }
      }

      if (heightsChanged) {
        tablesRowHeights[selectedTableIndex] = newRowHeights;

        notifyListeners();
      }
    }
  }

  void adjustSelectedColumnWidth(double newWidth) {
    if (tablesSelectedCells[selectedTableIndex].isNotEmpty) {
      List<double> newColumnWidths = List.from(tablesColumnWidths[selectedTableIndex]);
      bool widthsChanged = false;

      for (var cell in tablesSelectedCells[selectedTableIndex]) {
        if (newColumnWidths[cell.colIndex] != newWidth) {
          newColumnWidths[cell.colIndex] = newWidth;
          widthsChanged = true;
        }
      }

      if (widthsChanged) {
        tablesColumnWidths[selectedTableIndex] = newColumnWidths;

        notifyListeners();
      }
    }
  }

  void combineCells() {
    if (!checkSelectCell()) return;

    if (tablesSelectedCells[selectedTableIndex].length > 1) {
      // Sort the selected cells by row and column index
      tablesSelectedCells[selectedTableIndex].sort((a, b) {
        if (a.rowIndex != b.rowIndex) {
          return a.rowIndex.compareTo(b.rowIndex);
        } else {
          return a.colIndex.compareTo(b.colIndex);
        }
      });

      var topLeftCell = tablesSelectedCells[selectedTableIndex].first;

      // Calculate the full extent of the merge area considering current spans
      int minRowIndex = topLeftCell.rowIndex;
      int maxRowIndex = topLeftCell.rowIndex + topLeftCell.rowSpan - 1;
      int minColIndex = topLeftCell.colIndex;
      int maxColIndex = topLeftCell.colIndex + topLeftCell.colSpan - 1;

      for (var cell in tablesSelectedCells[selectedTableIndex]) {
        minRowIndex = minRowIndex < cell.rowIndex ? minRowIndex : cell.rowIndex;
        maxRowIndex = maxRowIndex > (cell.rowIndex + cell.rowSpan - 1)
            ? maxRowIndex
            : (cell.rowIndex + cell.rowSpan - 1);
        minColIndex = minColIndex < cell.colIndex ? minColIndex : cell.colIndex;
        maxColIndex = maxColIndex > (cell.colIndex + cell.colSpan - 1)
            ? maxColIndex
            : (cell.colIndex + cell.colSpan - 1);
      }

      // Set the new span for the top-left cell
      topLeftCell.rowSpan = (maxRowIndex - minRowIndex + 1);
      topLeftCell.colSpan = (maxColIndex - minColIndex + 1);

      // Remove the other cells that were merged into the topLeftCell
      tablesCells[selectedTableIndex].removeWhere((cell) {
        return cell != topLeftCell &&
            cell.rowIndex >= minRowIndex &&
            cell.rowIndex <= maxRowIndex &&
            cell.colIndex >= minColIndex &&
            cell.colIndex <= maxColIndex;
      });

      // Clear all selections after combining cells
      for (var cell in tablesCells[selectedTableIndex]) {
        cell.isTapped = false;
        cell.isLongPressed = false;
      }
      tablesSelectedCells[selectedTableIndex].clear();
    }

    saveCurrentTableState();
    notifyListeners();
  }

  void splitCells() {
    if (!checkSelectCell()) return;

    if (tablesSelectedCells[selectedTableIndex].length == 1) {
      var cell = tablesSelectedCells[selectedTableIndex].first;
      List<GridCell> newCells = [];

      // Split horizontally if the cell spans multiple columns
      for (int i = 0; i < cell.colSpan; i++) {
        newCells.add(GridCell(text: '', rowIndex: cell.rowIndex, colIndex: cell.colIndex + i));
      }

      // Split vertically if the cell spans multiple rows
      for (int j = 1; j < cell.rowSpan; j++) {
        for (int i = 0; i < cell.colSpan; i++) {
          newCells.add(GridCell(text: '', rowIndex: cell.rowIndex + j, colIndex: cell.colIndex + i));
        }
      }

      // Add new cells and remove the combined cell
      tablesCells[selectedTableIndex].remove(cell);
      tablesCells[selectedTableIndex].addAll(newCells);

      // Clear all selections after splitting
      tablesSelectedCells[selectedTableIndex].clear();
    }

    saveCurrentTableState();
    notifyListeners();
  }

  /// ==================== CELL EDITING ====================
  void updateSelectedCellText(String value, {bool saveState = true}) {
    if (!checkSelectCell()) return;

    if (!_hasValidTable || tablesSelectedCells[selectedTableIndex].isEmpty) return;

    inputText = value;
    for (var cell in tablesSelectedCells[selectedTableIndex]) {
      cell.text = value;
    }

    if (saveState) {
      _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 600), saveCurrentTableState);
    }
    notifyListeners();
  }

  /// ==================== TABLE CELL STYLE ====================
  void setIsDottedLineUpdateFlag(bool flag) {
    tableBorderStyle[selectedTableIndex] = flag;

    saveCurrentTableState();
    notifyListeners();
  }

  void tableWidth(double value) {
    if (!checkSelectCell()) return;

    if (tablesSelectedCells[selectedTableIndex].isNotEmpty) {
      tableLineWidth[selectedTableIndex] = value;
    }

    saveCurrentTableState();
    notifyListeners();
  }

  void tableToggleBold(bool isBold) => _updateCellProperty((c) => c.isBold = isBold);

  void tableToggleItalic(bool isItalic) => _updateCellProperty((c) => c.isItalic = isItalic);

  void tableToggleUnderline(bool isUnderline) => _updateCellProperty((c) => c.isUnderline = isUnderline);

  void changeAlignment(Alignment align, {TextAlign textAlign = TextAlign.center}) => _updateCellProperty((c) {
    c.alignment = align;
    c.textAlign = textAlign;
  });

  void updateFontSize(double size) => _updateCellProperty((c) => c.fontSize = size);

  void fontRotateFunction() => _updateCellProperty((c) => c.rotation = (c.rotation + 1) % 4);

  void _updateCellProperty(void Function(GridCell cell) updater) {
    if (!_hasValidTable || tablesSelectedCells[selectedTableIndex].isEmpty) return;
    for (var cell in tablesSelectedCells[selectedTableIndex]) {
      updater(cell);
    }
    saveCurrentTableState();
    notifyListeners();
  }

  void updateFontFamily(BuildContext context, String newFont) async {
    if (!checkSelectCell()) return;

    final selectedCells = tablesSelectedCells[selectedTableIndex];

    final selected = allFonts.firstWhere(
      (f) => f.name == newFont,
      orElse: () {
        debugPrint('Font not found: $newFont');
        return FontData(name: '', ext: '');
      },
    );
    if (selected.name.isEmpty || selected.ext.isEmpty) return;
    await loadFontFromJson(selected);

    if (selectedCells.isEmpty) {
      var cell = getSelectedCell();
      if (cell != null) cell.fontFamily = newFont;
    } else {
      for (var cell in selectedCells) {
        cell.fontFamily = newFont;
      }
    }

    saveCurrentTableState();
    notifyListeners();
  }
}

/// Table add row column helper class
enum TableAction { rowTop, rowBottom, colLeft, colRight }

extension TableActionX on TableAction {
  bool get isRow => this == TableAction.rowTop || this == TableAction.rowBottom;
  bool get isColumn => this == TableAction.colLeft || this == TableAction.colRight;

  // for direction calculation
  int get rowOffset => switch (this) {
    TableAction.rowTop => 0,
    TableAction.rowBottom => 1,
    _ => 0,
  };

  int get colOffset => switch (this) {
    TableAction.colLeft => 0,
    TableAction.colRight => 1,
    _ => 0,
  };
}

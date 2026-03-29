import 'package:fluent_ui/fluent_ui.dart';
import '../../../features/new_label/label/view/dashboard_option/templated_container/show_widget_class/table_widget_class.dart';

class TableState {
  final String inputText;
  final List<String> tableCodes;
  final List<Offset> tableOffsets;
  final List<int> rowCount;
  final List<int> columnCount;
  final List<double> tableLineWidth;
  final List<List<GridCell>> tablesCells;
  final List<List<double>> tablesRowHeights;
  final List<List<double>> tablesColumnWidths;
  final List<List<GridCell>> tablesSelectedCells;
  final List<double> tableContainerRotations;
  final List<bool> tableBorderStyle;
  final List<bool> isTableLock;

  final bool tableBorder;
  final bool showTableWidget;
  final bool showTableContainerFlag;
  final int selectedColIndex;
  final int selectedRowIndex;
  final int selectedTableIndex;

  TableState({
    required this.inputText,
    required this.tableCodes,
    required this.tableOffsets,
    required this.rowCount,
    required this.columnCount,
    required this.tableLineWidth,
    required this.tablesCells,
    required this.tablesRowHeights,
    required this.tablesColumnWidths,
    required this.tablesSelectedCells,
    required this.isTableLock,

    required this.tableBorder,
    required this.showTableWidget,
    required this.showTableContainerFlag,
    required this.selectedColIndex,
    required this.selectedRowIndex,
    required this.selectedTableIndex,
    required this.tableContainerRotations,
    required this.tableBorderStyle,
  });

  /// Completely empty state – handy for clearing the canvas.
  factory TableState.empty() => TableState(
    inputText: "",
    tableCodes: const [],
    tableOffsets: const [],
    rowCount: const [],
    columnCount: const [],
    tableLineWidth: const [],
    tablesCells: const [],
    tablesRowHeights: const [],
    tablesColumnWidths: const [],
    tablesSelectedCells: const [],
    isTableLock: const [],
    tableBorder: false,
    showTableWidget: false,
    showTableContainerFlag: false,
    selectedColIndex: -1,
    selectedRowIndex: -1,
    selectedTableIndex: -1,
    tableContainerRotations: const [],
    tableBorderStyle: const [],
  );

  // ----------- Deep copy helpers -----------
  static List<List<T>> deepCopyNestedList<T>(List<List<T>> source) {
    return source.map((inner) => List<T>.from(inner)).toList();
  }

  static List<List<GridCell>> deepCopyTablesCells(List<List<GridCell>> source) {
    return source.map((row) => row.map((c) => c.copyWith()).toList()).toList();
  }

  // ----------- Snapshot factory -----------
  /// Take a safe snapshot from your provider’s live data.
  factory TableState.snapshot({
    required String inputText,
    required List<String> tableCodes,
    required List<Offset> tableOffsets,
    required List<int> rowCount,
    required List<int> columnCount,
    required List<double> tableLineWidth,
    required List<List<GridCell>> tablesCells,
    required List<List<double>> tablesRowHeights,
    required List<List<double>> tablesColumnWidths,
    required List<List<GridCell>> tablesSelectedCells,
    required List<bool> tableBorderStyle,
    required List<bool> isTableLock,
    required bool tableBorder,
    required bool showTableWidget,
    required bool showTableContainerFlag,
    required int selectedColIndex,
    required int selectedRowIndex,
    required int selectedTableIndex,
    required List<double> tableContainerRotations,
  }) {
    return TableState(
      inputText: inputText,
      tableCodes: List<String>.from(tableCodes),
      tableOffsets: List<Offset>.from(tableOffsets),
      rowCount: List<int>.from(rowCount),
      columnCount: List<int>.from(columnCount),
      tableLineWidth: List<double>.from(tableLineWidth),
      tablesCells: deepCopyTablesCells(tablesCells),
      tablesRowHeights: deepCopyNestedList(tablesRowHeights),
      tablesColumnWidths: deepCopyNestedList(tablesColumnWidths),
      tablesSelectedCells: deepCopyTablesCells(tablesSelectedCells),
      tableBorderStyle: List<bool>.from(tableBorderStyle),
      isTableLock: List<bool>.from(isTableLock),
      tableBorder: tableBorder,
      showTableWidget: showTableWidget,
      showTableContainerFlag: showTableContainerFlag,
      selectedColIndex: selectedColIndex,
      selectedRowIndex: selectedRowIndex,
      selectedTableIndex: selectedTableIndex,
      tableContainerRotations: List<double>.from(tableContainerRotations),
    );
  }

  // ----------- copyWith (immutable-friendly) -----------
  TableState copyWith({
    String? inputText,
    List<String>? tableCodes,
    List<Offset>? tableOffsets,
    List<int>? rowCount,
    List<int>? columnCount,
    List<double>? tableLineWidth,
    List<List<GridCell>>? tablesCells,
    List<List<double>>? tablesRowHeights,
    List<List<double>>? tablesColumnWidths,
    List<List<GridCell>>? tablesSelectedCells,
    List<bool>? isTableLock,
    bool? tableBorder,
    bool? showTableWidget,
    bool? showTableContainerFlag,
    int? selectedColIndex,
    int? selectedRowIndex,
    int? selectedTableIndex,
    List<double>? tableContainerRotations,
    List<bool>? tableBorderStyle,
  }) {
    return TableState(
      inputText: inputText ?? this.inputText,
      tableCodes: tableCodes ?? List<String>.from(this.tableCodes),
      tableOffsets: tableOffsets ?? List<Offset>.from(this.tableOffsets),
      rowCount: rowCount ?? List<int>.from(this.rowCount),
      columnCount: columnCount ?? List<int>.from(this.columnCount),
      tableLineWidth: tableLineWidth ?? List<double>.from(this.tableLineWidth),
      tablesCells: tablesCells != null
          ? deepCopyTablesCells(tablesCells)
          : deepCopyTablesCells(this.tablesCells),
      tablesRowHeights: tablesRowHeights != null
          ? deepCopyNestedList(tablesRowHeights)
          : deepCopyNestedList(this.tablesRowHeights),
      tablesColumnWidths: tablesColumnWidths != null
          ? deepCopyNestedList(tablesColumnWidths)
          : deepCopyNestedList(this.tablesColumnWidths),
      tablesSelectedCells: tablesSelectedCells != null
          ? deepCopyTablesCells(tablesSelectedCells)
          : deepCopyTablesCells(this.tablesSelectedCells),
      isTableLock: isTableLock ?? List<bool>.from(this.isTableLock),

      tableBorder: tableBorder ?? this.tableBorder,
      showTableWidget: showTableWidget ?? this.showTableWidget,
      showTableContainerFlag:
          showTableContainerFlag ?? this.showTableContainerFlag,
      selectedColIndex: selectedColIndex ?? this.selectedColIndex,
      selectedRowIndex: selectedRowIndex ?? this.selectedRowIndex,
      selectedTableIndex: selectedTableIndex ?? this.selectedTableIndex,
      tableContainerRotations:
          tableContainerRotations ??
          List<double>.from(this.tableContainerRotations),
      tableBorderStyle:
          tableBorderStyle ?? List<bool>.from(this.tableBorderStyle),
    );
  }

  /*  // ---------- Equatable / Comparison ----------
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TableState &&
          runtimeType == other.runtimeType &&
          inputText == other.inputText &&
          _listEquals(tableCodes, other.tableCodes) &&
          _listEquals(tableOffsets, other.tableOffsets) &&
          _listEquals(rowCount, other.rowCount) &&
          _listEquals(columnCount, other.columnCount) &&
          _listEquals(tableLineWidth, other.tableLineWidth) &&
          _deepListEquals(tablesCells, other.tablesCells) &&
          tableBorder == other.tableBorder &&
          showTableWidget == other.showTableWidget &&
          showTableContainerFlag == other.showTableContainerFlag &&
          selectedColIndex == other.selectedColIndex &&
          selectedRowIndex == other.selectedRowIndex &&
          selectedTableIndex == other.selectedTableIndex &&
          _listEquals(tableContainerRotations, other.tableContainerRotations) &&
          _listEquals(tableBorderStyle, other.tableBorderStyle);

  @override
  int get hashCode =>
      inputText.hashCode ^
      tableCodes.hashCode ^
      tableOffsets.hashCode ^
      rowCount.hashCode ^
      columnCount.hashCode ^
      tableLineWidth.hashCode ^
      tablesCells.hashCode ^
      tableBorder.hashCode ^
      showTableWidget.hashCode ^
      showTableContainerFlag.hashCode ^
      selectedColIndex.hashCode ^
      selectedRowIndex.hashCode ^
      selectedTableIndex.hashCode ^
      tableContainerRotations.hashCode ^
      tableBorderStyle.hashCode;

  // ---------- Helpers for deep list equality ----------
  static bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null || b == null) return a == b;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  static bool _deepListEquals<T>(List<List<T>>? a, List<List<T>>? b) {
    if (a == null || b == null) return a == b;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (!_listEquals(a[i], b[i])) return false;
    }
    return true;
  }*/
}

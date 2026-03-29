import 'package:flutter/material.dart';

class LineState {
  final List<String> lineCodes;
  final List<Offset> lineOffsets;
  final List<double> lineCodesContainerRotations;
  final List<double> updateSliderLineWidth;
  final List<bool> isDottedLineUpdate;
  final List<double> updateLineWidth;
  final List<bool> isLineLock;
  final bool showLineWidget;
  final bool showLineContainerFlag;
  final bool lineBorder;
  final int selectedLineIndex;

  LineState({
    required this.lineCodes,
    required this.lineOffsets,
    required this.lineCodesContainerRotations,
    required this.updateSliderLineWidth,
    required this.isDottedLineUpdate,
    required this.updateLineWidth,
    required this.isLineLock,
    required this.showLineWidget,
    required this.showLineContainerFlag,
    required this.lineBorder,
    required this.selectedLineIndex,
  });

  /// 🔥 empty factory for reset
  factory LineState.empty() {
    return LineState(
      lineCodes: [],
      lineOffsets: [],
      lineCodesContainerRotations: [],
      updateSliderLineWidth: [],
      isDottedLineUpdate: [],
      updateLineWidth: [],
      isLineLock: [],
      showLineWidget: false,
      showLineContainerFlag: false,
      lineBorder: false,
      selectedLineIndex: -1,
    );
  }

  /// 🛠 copyWith for updating partial state
  LineState copyWith({
    List<String>? lineCodes,
    List<Offset>? lineOffsets,
    List<double>? lineCodesContainerRotations,
    List<double>? updateSliderLineWidth,
    List<bool>? isDottedLineUpdate,
    List<double>? updateLineWidth,
    List<bool>? isLineLock,
    bool? showLineWidget,
    bool? showLineContainerFlag,
    bool? lineBorder,
    int? selectedLineIndex,
  }) {
    return LineState(
      lineCodes: lineCodes ?? List.from(this.lineCodes),
      lineOffsets: lineOffsets ?? List.from(this.lineOffsets),
      lineCodesContainerRotations:
          lineCodesContainerRotations ??
          List.from(this.lineCodesContainerRotations),
      updateSliderLineWidth:
          updateSliderLineWidth ?? List.from(this.updateSliderLineWidth),
      isDottedLineUpdate:
          isDottedLineUpdate ?? List.from(this.isDottedLineUpdate),
      updateLineWidth: updateLineWidth ?? List.from(this.updateLineWidth),
      isLineLock: isLineLock ?? List.from(this.isLineLock),
      showLineWidget: showLineWidget ?? this.showLineWidget,
      showLineContainerFlag:
          showLineContainerFlag ?? this.showLineContainerFlag,
      lineBorder: lineBorder ?? this.lineBorder,
      selectedLineIndex: selectedLineIndex ?? this.selectedLineIndex,
    );
  }
}

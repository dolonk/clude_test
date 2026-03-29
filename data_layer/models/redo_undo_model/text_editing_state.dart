import 'package:flutter/material.dart';

class TextEditingState {
  final List<String> textCodes;
  final List<Offset> textCodeOffsets;
  final List<FocusNode> textFocusNodes;
  final List<TextEditingController> textControllers;
  final List<double> textContainerRotations;
  final List<bool> updateTextBold;
  final List<bool> updateTextItalic;
  final List<bool> updateTextUnderline;
  final List<bool> updateTextStrikeThrough;
  final List<TextAlign> updateTextAlignment;
  final List<bool> alignLeft;
  final List<bool> alignCenter;
  final List<bool> alignRight;
  final List<bool> alignStraight;
  final List<double> updateTextFontSize;
  final List<double> updateTextWidthSize;
  final List<double> updateTextHeightSize;
  final List<String> textSelectedFontFamily;
  final List<bool> isTextLock;

  final bool textBorder;
  final bool showTextEditingWidget;
  final bool showTextEditingContainerFlag;
  final int selectedTextIndex;

  TextEditingState({
    required this.textCodes,
    required this.textCodeOffsets,
    required this.textFocusNodes,
    required this.textControllers,
    required this.textContainerRotations,
    required this.updateTextBold,
    required this.updateTextItalic,
    required this.updateTextUnderline,
    required this.updateTextStrikeThrough,
    required this.updateTextAlignment,
    required this.alignLeft,
    required this.alignCenter,
    required this.alignRight,
    required this.alignStraight,
    required this.updateTextFontSize,
    required this.updateTextWidthSize,
    required this.updateTextHeightSize,
    required this.textSelectedFontFamily,
    required this.isTextLock,
    required this.textBorder,
    required this.showTextEditingWidget,
    required this.showTextEditingContainerFlag,
    required this.selectedTextIndex,
  });

  factory TextEditingState.empty() {
    return TextEditingState(
      textCodes: [],
      textCodeOffsets: [],
      textFocusNodes: [],
      textControllers: [],
      textContainerRotations: [],
      updateTextBold: [],
      updateTextItalic: [],
      updateTextUnderline: [],
      updateTextStrikeThrough: [],
      updateTextAlignment: [],
      alignLeft: [],
      alignCenter: [],
      alignRight: [],
      alignStraight: [],
      updateTextFontSize: [],
      updateTextWidthSize: [],
      updateTextHeightSize: [],
      textSelectedFontFamily: [],
      isTextLock: [],
      textBorder: false,
      showTextEditingWidget: false,
      showTextEditingContainerFlag: false,
      selectedTextIndex: -1,
    );
  }

  TextEditingState copyWith({
    List<String>? textCodes,
    List<Offset>? textCodeOffsets,
    List<FocusNode>? textFocusNodes,
    List<TextEditingController>? textControllers,
    List<double>? textContainerRotations,
    List<bool>? updateTextBold,
    List<bool>? updateTextItalic,
    List<bool>? updateTextUnderline,
    List<bool>? updateTextStrikeThrough,
    List<TextAlign>? updateTextAlignment,
    List<bool>? alignLeft,
    List<bool>? alignCenter,
    List<bool>? alignRight,
    List<bool>? alignStraight,
    List<double>? updateTextFontSize,
    List<double>? updateTextWidthSize,
    List<double>? updateTextHeightSize,
    List<String>? textSelectedFontFamily,
    List<bool>? isTextLock,
    bool? textBorder,
    bool? showTextEditingWidget,
    bool? showTextEditingContainerFlag,
    int? selectedTextIndex,
  }) {
    return TextEditingState(
      textCodes: textCodes ?? List.from(this.textCodes),
      textCodeOffsets: textCodeOffsets ?? List.from(this.textCodeOffsets),
      textFocusNodes: textFocusNodes ?? List.from(this.textFocusNodes),
      textControllers: textControllers ?? List.from(this.textControllers),
      textContainerRotations:
          textContainerRotations ?? List.from(this.textContainerRotations),
      updateTextBold: updateTextBold ?? List.from(this.updateTextBold),
      updateTextItalic: updateTextItalic ?? List.from(this.updateTextItalic),
      updateTextUnderline:
          updateTextUnderline ?? List.from(this.updateTextUnderline),
      updateTextStrikeThrough:
          updateTextStrikeThrough ?? List.from(this.updateTextStrikeThrough),
      updateTextAlignment:
          updateTextAlignment ?? List.from(this.updateTextAlignment),
      alignLeft: alignLeft ?? List.from(this.alignLeft),
      alignCenter: alignCenter ?? List.from(this.alignCenter),
      alignRight: alignRight ?? List.from(this.alignRight),
      alignStraight: alignStraight ?? List.from(this.alignStraight),
      updateTextFontSize:
          updateTextFontSize ?? List.from(this.updateTextFontSize),
      updateTextWidthSize:
          updateTextWidthSize ?? List.from(this.updateTextWidthSize),
      updateTextHeightSize:
          updateTextHeightSize ?? List.from(this.updateTextHeightSize),
      textSelectedFontFamily:
          textSelectedFontFamily ?? List.from(this.textSelectedFontFamily),
      isTextLock: isTextLock ?? List.from(this.isTextLock),
      textBorder: textBorder ?? this.textBorder,
      showTextEditingWidget:
          showTextEditingWidget ?? this.showTextEditingWidget,
      showTextEditingContainerFlag:
          showTextEditingContainerFlag ?? this.showTextEditingContainerFlag,
      selectedTextIndex: selectedTextIndex ?? this.selectedTextIndex,
    );
  }
}

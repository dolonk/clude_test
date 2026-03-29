import 'package:fluent_ui/fluent_ui.dart';

class EmojiState {
  final List<String> emojiCodes;
  final List<dynamic> selectedEmojis;
  final List<Offset> emojiCodeOffsets;
  final List<double> updatedEmojiWidth;
  final List<double> emojiCodesContainerRotations;
  final List<bool> isEmojiLock;

  final bool showEmojiWidget;
  final bool showEmojiContainerFlag;
  final String? selectedEmojiCategory;
  final bool emojiBorder;
  final int selectedEmojiIndex;

  EmojiState({
    required this.emojiCodes,
    required this.selectedEmojis,
    required this.emojiCodeOffsets,
    required this.updatedEmojiWidth,
    required this.emojiCodesContainerRotations,
    required this.isEmojiLock,

    required this.showEmojiWidget,
    required this.showEmojiContainerFlag,
    required this.selectedEmojiCategory,
    required this.emojiBorder,
    required this.selectedEmojiIndex,
  });

  factory EmojiState.empty() {
    return EmojiState(
      emojiCodes: [],
      selectedEmojis: [],
      emojiCodeOffsets: [],
      updatedEmojiWidth: [],
      emojiCodesContainerRotations: [],
      isEmojiLock: [],

      showEmojiWidget: false,
      showEmojiContainerFlag: false,
      selectedEmojiCategory: null,
      emojiBorder: false,
      selectedEmojiIndex: -1,
    );
  }

  EmojiState copyWith({
    List<String>? emojiCodes,
    List<dynamic>? selectedEmojis,
    List<Offset>? emojiCodeOffsets,
    List<double>? updatedEmojiWidth,
    List<double>? emojiCodesContainerRotations,
    List<bool>? isEmojiLock,
    bool? emojiBorder,
    bool? showEmojiWidget,
    bool? showEmojiContainerFlag,
    String? selectedEmojiCategory,
    int? selectedEmojiIndex,
  }) {
    return EmojiState(
      emojiCodes: emojiCodes ?? List.from(this.emojiCodes),
      selectedEmojis: selectedEmojis ?? List.from(this.selectedEmojis),
      emojiCodeOffsets: emojiCodeOffsets ?? List.from(this.emojiCodeOffsets),
      updatedEmojiWidth: updatedEmojiWidth ?? List.from(this.updatedEmojiWidth),
      emojiCodesContainerRotations:
          emojiCodesContainerRotations ??
          List.from(this.emojiCodesContainerRotations),
      isEmojiLock: isEmojiLock ?? List.from(this.isEmojiLock),
      showEmojiWidget: showEmojiWidget ?? this.showEmojiWidget,
      showEmojiContainerFlag:
          showEmojiContainerFlag ?? this.showEmojiContainerFlag,
      selectedEmojiCategory:
          selectedEmojiCategory ?? this.selectedEmojiCategory,
      emojiBorder: emojiBorder ?? this.emojiBorder,
      selectedEmojiIndex: selectedEmojiIndex ?? this.selectedEmojiIndex,
    );
  }
}

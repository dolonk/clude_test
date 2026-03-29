import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../common/common_function_provider.dart';
import '../../../../../utils/extension/global_context.dart';
import '../../../../../common/redo_undo/undo_redo_manager.dart';
import '../../../../../utils/constants/label_global_variable.dart';
import '../../../../../common/clipboard_service/clipboard_service.dart';

import 'package:grozziie/utils/extension/provider_extension.dart';
import '../../../../../data_layer/models/redo_undo_model/emoji_state.dart';
import '../../../../../data_layer/models/emoji_model/emoji_model_class.dart';
import '../../../../../data_layer/repositories/emoji_repository/emoji_repository.dart';

class EmojiProvider extends ChangeNotifier {
  CommonFunctionProvider commonModel = CommonFunctionProvider();

  final _myRepo = EmojiRepository();
  bool isLoadingCategories = true;
  String? categoryError;
  List<EmojiModelClass>? emojiCategories;
  List<EmojiModelClass> emojiImages = [];
  int _pasteCount = 0;

  EmojiProvider() {
    fetchEmojiCategoriesApi();
  }

  /// ================== Undo / Redo ==================
  void saveCurrentEmojiState() {
    final context = GlobalContext.context;
    if (context == null) return;

    final snapshot = EmojiState(
      emojiCodes: List.from(emojiCodes),
      selectedEmojis: List.from(selectedEmojis),
      emojiCodeOffsets: List.from(emojiCodeOffsets),
      updatedEmojiWidth: List.from(updatedEmojiWidth),
      emojiCodesContainerRotations: List.from(emojiCodesContainerRotations),
      isEmojiLock: List.from(isEmojiLock),
      showEmojiWidget: showEmojiWidget,
      showEmojiContainerFlag: showEmojiContainerFlag,
      selectedEmojiCategory: selectedEmojiCategory,
      emojiBorder: emojiBorder,
      selectedEmojiIndex: selectedEmojiIndex,
    );

    context.undoRedoProvider.addAction(
      ActionState(type: "Emoji", state: snapshot, restore: (s) => _restoreEmojiState(s as EmojiState)),
    );
  }

  void _restoreEmojiState(EmojiState state) {
    emojiCodes = List.from(state.emojiCodes);
    selectedEmojis = List.from(state.selectedEmojis);
    emojiCodeOffsets = List.from(state.emojiCodeOffsets);
    updatedEmojiWidth = List.from(state.updatedEmojiWidth);
    emojiCodesContainerRotations = List.from(state.emojiCodesContainerRotations);
    isEmojiLock = List.from(state.isEmojiLock);
    showEmojiWidget = state.showEmojiWidget;
    showEmojiContainerFlag = state.showEmojiContainerFlag;
    selectedEmojiCategory = state.selectedEmojiCategory;
    emojiBorder = state.emojiBorder;
    selectedEmojiIndex = state.selectedEmojiIndex;
    notifyListeners();
  }

  /// ==================== COPY / PASTE ====================
  Future<void> copyEmojiWidget() async {
    final context = GlobalContext.context;
    if (context == null) return;
    _pasteCount = 0;

    final snapshot = EmojiState(
      emojiCodes: [emojiCodes[selectedEmojiIndex]],
      selectedEmojis: [selectedEmojis[selectedEmojiIndex]],
      emojiCodeOffsets: [emojiCodeOffsets[selectedEmojiIndex]],
      updatedEmojiWidth: [updatedEmojiWidth[selectedEmojiIndex]],
      emojiCodesContainerRotations: [emojiCodesContainerRotations[selectedEmojiIndex]],
      isEmojiLock: [isEmojiLock[selectedEmojiIndex]],
      showEmojiWidget: showEmojiWidget,
      showEmojiContainerFlag: showEmojiContainerFlag,
      selectedEmojiCategory: selectedEmojiCategory,
      emojiBorder: emojiBorder,
      selectedEmojiIndex: selectedEmojiIndex,
    );

    context.copyPasteProvider.copy(ClipboardItem(type: "emoji", state: snapshot));
  }

  Future<void> pasteEmojiWidget(ClipboardItem clipboard) async {
    commonModel.clearAllBorder();
    final context = GlobalContext.context;
    if (context == null) return;

    if (clipboard.state is! EmojiState) return;
    final pastedState = clipboard.state as EmojiState;

    _pasteCount++;
    Offset shift = Offset(10.0 * _pasteCount, 50.0 * _pasteCount);

    emojiCodes.addAll(pastedState.emojiCodes);
    selectedEmojis.addAll(pastedState.selectedEmojis);
    emojiCodeOffsets.addAll(pastedState.emojiCodeOffsets.map((offset) => offset + shift));
    updatedEmojiWidth.addAll(pastedState.updatedEmojiWidth);
    emojiCodesContainerRotations.addAll(pastedState.emojiCodesContainerRotations);
    isEmojiLock.add(false);

    emojiBorder = true;
    selectedEmojiIndex = emojiCodes.length - 1;

    context.copyPasteProvider.clear();
    saveCurrentEmojiState();
    notifyListeners();
  }

  /// ================== API / Image Handling ==================
  Future<void> fetchEmojiCategoriesApi() async {
    isLoadingCategories = true;
    categoryError = null;
    emojiCategories?.clear();
    emojiImages.clear();
    notifyListeners();
    try {
      List<EmojiModelClass> categories = await _myRepo.fetchEmojiCategories();
      emojiCategories = categories;

      if (categories.isNotEmpty) {
        selectedEmojiCategory = categories[0].en;
        loadEmojiImages(selectedEmojiCategory!);
      }

      isLoadingCategories = false;
    } catch (error) {
      isLoadingCategories = false;
      categoryError = error.toString();
    }
    notifyListeners();
  }

  Future<void> loadEmojiImages(String categoryName) async {
    try {
      emojiImages = await _myRepo.fetchEmojiImages(categoryName);
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching images: $e');
    }
  }

  void getEmojiImageList(String categoriesName) async {
    selectedEmojiCategory = categoriesName;
    await loadEmojiImages(selectedEmojiCategory!);
    notifyListeners();
  }

  Future<Uint8List?> downloadImage(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) return response.bodyBytes;
      throw Exception('Failed to download image');
    } catch (e) {
      debugPrint('Error downloading image: $e');
      return null;
    }
  }

  /// ================== Widget Handlers ==================
  void setEmojiWidget(bool flag) {
    showEmojiWidget = flag;
    saveCurrentEmojiState();
    notifyListeners();
  }

  void generateEmojiItems(dynamic selectImage) {
    commonModel.generateBorderOff('emoji', true);

    emojiCodes.add('Icon');
    emojiCodeOffsets.add(Offset(0, (emojiCodes.length * 5).toDouble()));
    selectedEmojis.add(selectImage);
    emojiCodesContainerRotations.add(0);
    updatedEmojiWidth.add(50);
    isEmojiLock.add(false);
    selectedEmojiIndex = emojiCodes.length - 1;

    saveCurrentEmojiState();
    notifyListeners();
  }

  void handleResizeGesture(DragUpdateDetails details, int? iconIndex) {
    const minEmojiWidth = 30.0;
    if (selectedEmojiIndex == iconIndex) {
      final newEmojiSize = updatedEmojiWidth[selectedEmojiIndex] + details.delta.dx;
      updatedEmojiWidth[selectedEmojiIndex] = newEmojiSize >= minEmojiWidth ? newEmojiSize : minEmojiWidth;
    }
    notifyListeners();
  }

  void deleteEmojiItems(int iconIndex) {
    saveCurrentEmojiState();

    if (iconIndex < 0 || iconIndex >= emojiCodes.length) return;

    emojiCodes.removeAt(iconIndex);
    emojiBorder = false;

    if (iconIndex < emojiCodeOffsets.length) emojiCodeOffsets.removeAt(iconIndex);
    if (iconIndex < selectedEmojis.length) selectedEmojis.removeAt(iconIndex);
    if (iconIndex < updatedEmojiWidth.length) updatedEmojiWidth.removeAt(iconIndex);
    if (iconIndex < emojiCodesContainerRotations.length) emojiCodesContainerRotations.removeAt(iconIndex);
    if (iconIndex < isEmojiLock.length) {
      isEmojiLock.removeAt(iconIndex);
    }

    saveCurrentEmojiState();
    notifyListeners();
  }
}

import 'package:flutter/foundation.dart';
import '../../../utils/constants/api_constants.dart';
import '../../../utils/network_section/dhttp_services.dart';
import '../../models/emoji_model/emoji_model_class.dart';

class EmojiRepository {
  /// Emoji categories section
  Future<List<EmojiModelClass>> fetchEmojiCategories() async {
    try {
      final response = await DHttpServices.get(
        endpoint: AppUrl.emojiCategoriesUrl,
      );
      List<dynamic> responseData = response as List<dynamic>;

      List<EmojiModelClass> categories = responseData
          .map((json) => EmojiModelClass.fromJson(json))
          .toList();

      return categories;
    } catch (e) {
      debugPrint('API Error (fetchEmojiCategories): $e');
      rethrow;
    }
  }

  /// Emoji Image section
  Future<List<EmojiModelClass>> fetchEmojiImages(String categoriesName) async {
    try {
      final response = await DHttpServices.get(
        endpoint: AppUrl.emojiUrl(categoriesName),
      );
      List<dynamic> responseData = response as List<dynamic>;
      List<EmojiModelClass> categories = responseData
          .map((json) => EmojiModelClass.fromJson(json))
          .toList();
      return categories;
    } catch (e) {
      debugPrint('API Error (fetchEmojiImages): $e');
      rethrow;
    }
  }
}

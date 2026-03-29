import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'animation_loader.dart';

class DFullScreenLoader {
  /// Open a full-screen loading dialog with a given text and animation.
  static void openLoadingDialog(
    BuildContext context,
    String text,
    String animation,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false, // disable popping ith the back button
        child: Container(
          color: DColors.white,
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DAnimationLoaderWidget(text: text, animation: animation),
            ],
          ),
        ),
      ),
    );
  }

  /// Stop the current open loading dialog.
  static void stopLoading(BuildContext context) {
    Navigator.of(context).pop(); // Close the Dialog using the Navigator.
  }
}

import 'dart:typed_data';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grozziie/localization/main_texts.dart';
import 'package:grozziie/utils/constants/label_global_variable.dart';
import 'package:grozziie/utils/constants/sizes.dart';
import 'package:grozziie/utils/extension/text_extension.dart';

class TemplateCard extends StatelessWidget {
  const TemplateCard({
    super.key,
    required this.imageUrl,
    required this.tName,
    required this.tWidth,
    required this.tHeight,
    required this.onDelete,
  });
  final Uint8List imageUrl;
  final String tName;
  final String tWidth;
  final String tHeight;
  final void Function() onDelete;

  @override
  Widget build(BuildContext context) {
    final dTexts = DTexts.instance;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Image view Templated
          Expanded(
            child: Container(
              color: Colors.white,
              child: Center(child: Image.memory(imageUrl)),
            ),
          ),
          const SizedBox(height: DSizes.spaceBtwItems),

          SizedBox(
            height: 74.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 250.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${dTexts.name}: $tName",
                        style: context.title,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${dTexts.size}: ${tWidth}mm*${tHeight}mm",
                        style: context.body,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                isAdmin
                    ? IconButton(
                        icon: const Icon(FluentIcons.delete, size: 24),
                        onPressed: onDelete,
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

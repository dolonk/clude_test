import 'dart:math';
import 'package:fluent_ui/fluent_ui.dart';
import '../../../../../../localization/main_texts.dart';
import 'package:grozziie/features/document_section/dot/provider/dot_image_provider.dart';

import '../../../../../../utils/constants/sizes.dart';

class DotImagePreViewSection extends StatelessWidget {
  const DotImagePreViewSection({super.key, required this.dotImageModel});
  final DotImageProvider dotImageModel;

  @override
  Widget build(BuildContext context) {
    final dTexts = DTexts.instance;
    return Expanded(
      flex: 2,
      child: Column(
        children: [
          /// Image show section
          Column(
            spacing: 4,
            children: [
              Transform.rotate(
                angle: dotImageModel.rotationDegree * (pi / 180),
                child: Container(
                  width: double.infinity,
                  height: 700,
                  color: const Color(0xff004368).withAlpha(20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    child: dotImageModel.isLoading
                        ? const Center(child: ProgressRing())
                        : dotImageModel.zoomPage
                        ? InteractiveViewer(
                            minScale: 1,
                            maxScale: 4,
                            child: Center(
                              child: Image.memory(
                                dotImageModel
                                    .allPdfPage[dotImageModel.startPage - 1],
                                fit: BoxFit.contain,
                              ),
                            ),
                          )
                        : Image.memory(
                            dotImageModel.allPdfPage[dotImageModel.startPage -
                                1],
                            fit: BoxFit.contain,
                          ),
                  ),
                ),
              ),
              Text("${dTexts.pageLoading}: ${dotImageModel.jumToPage}"),
            ],
          ),
          const SizedBox(height: 20),

          /// Crop & page show section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // crop
              Row(
                children: [
                  /// Checkbox all crop
                  Row(
                    children: [
                      Checkbox(
                        checked: dotImageModel.isAllPagesCropped,
                        onChanged: (value) =>
                            dotImageModel.setAllPageCrop(value!),
                      ),
                      SizedBox(width: DSizes.spaceBtwItems),
                      Text(dTexts.allPage),
                    ],
                  ),
                  SizedBox(width: DSizes.spaceBtwItems),

                  /// button crop
                  SizedBox(
                    height: 40,
                    child: FilledButton(
                      onPressed: () {
                        dotImageModel.setCrop(context);
                      },
                      child: Text(dTexts.cropPdf),
                    ),
                  ),
                ],
              ),

              //Page list
              ComboBox<int>(
                value: dotImageModel.startPage,
                onChanged: (value) {
                  if (value != null) dotImageModel.jumpToPage(value);
                },
                items: List.generate(dotImageModel.jumToPage, (index) {
                  final pageNum = index + 1;
                  return ComboBoxItem<int>(
                    value: pageNum,
                    child: Text('${dTexts.page} $pageNum'),
                  );
                }),
                iconEnabledColor: Colors.grey,
                iconSize: 16,
              ),

              // page
              SizedBox(
                width: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: dotImageModel.goToPreviousPage,
                      icon: const Icon(FluentIcons.caret_hollow_mirrored),
                      style: ButtonStyle(
                        foregroundColor: WidgetStateProperty.all(Colors.grey),
                        padding: WidgetStateProperty.all(
                          const EdgeInsets.all(0),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(child: Text('${dotImageModel.startPage}')),
                    ),
                    IconButton(
                      onPressed: dotImageModel.goToNextPage,
                      icon: const Icon(FluentIcons.caret_hollow),
                      style: ButtonStyle(
                        foregroundColor: WidgetStateProperty.all(Colors.grey),
                        padding: WidgetStateProperty.all(
                          const EdgeInsets.all(0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

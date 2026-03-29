import 'dart:math';
import 'package:fluent_ui/fluent_ui.dart';
import '../../../../../../localization/main_texts.dart';
import 'package:grozziie/features/document_section/dot/provider/dot_document_provider.dart';

import '../../../../../../utils/constants/sizes.dart';

class DotImageViewSection extends StatelessWidget {
  const DotImageViewSection({super.key, required this.dotDocModel});
  final DotDocumentProvider dotDocModel;

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
                angle: dotDocModel.rotationDegree * (pi / 180),
                child: Container(
                  width: double.infinity,
                  height: 700,
                  color: const Color(0xff004368).withAlpha(20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    child: dotDocModel.isLoading
                        ? const Center(child: ProgressRing())
                        : dotDocModel.zoomPage
                        ? InteractiveViewer(
                            minScale: 1,
                            maxScale: 4,
                            child: Center(
                              child: Image.memory(
                                dotDocModel.allPdfPage[dotDocModel.startPage -
                                    1],
                                fit: BoxFit.contain,
                              ),
                            ),
                          )
                        : Image.memory(
                            dotDocModel.allPdfPage[dotDocModel.startPage - 1],
                            fit: BoxFit.contain,
                          ),
                  ),
                ),
              ),
              Text("${dTexts.pageLoading}: ${dotDocModel.jumToPage}"),
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
                        checked: dotDocModel.isAllPagesCropped,
                        onChanged: (value) =>
                            dotDocModel.setAllPageCrop(value!),
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
                        dotDocModel.setCrop(context);
                      },
                      child: Text(dTexts.cropPdf),
                    ),
                  ),
                ],
              ),

              //Page list
              ComboBox<int>(
                value: dotDocModel.startPage,
                onChanged: (value) {
                  if (value != null) dotDocModel.jumpToPage(value);
                },
                items: List.generate(dotDocModel.jumToPage, (index) {
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
                      onPressed: dotDocModel.goToPreviousPage,
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
                      child: Center(child: Text('${dotDocModel.startPage}')),
                    ),
                    IconButton(
                      onPressed: dotDocModel.goToNextPage,
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

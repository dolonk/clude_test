import 'package:provider/provider.dart';
import 'package:fluent_ui/fluent_ui.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../utils/constants/icons.dart';
import '../../../../utils/snackbar_toast/snack_bar.dart';
import '../../../../../utils/popups/animation_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grozziie/localization/main_texts.dart';
import '../../../../utils/constants/label_global_variable.dart';
import 'package:grozziie/utils/extension/text_extension.dart';
import 'package:grozziie/utils/constants/animation_strings.dart';
import 'package:grozziie/utils/extension/provider_extension.dart';

import '../../../../common/print_select_header/common_printer_header_section.dart';
import 'package:grozziie/features/document_section/common/pick_file_picker_provider.dart';
import 'package:grozziie/features/new_label/printer_type/thermal/provider/thermal_paper_size_provider.dart';

class ThermalSelectDocument extends StatefulWidget {
  const ThermalSelectDocument({super.key});

  @override
  State<ThermalSelectDocument> createState() => _ThermalSelectDocumentState();
}

class _ThermalSelectDocumentState extends State<ThermalSelectDocument>
    with SingleTickerProviderStateMixin {
  late AnimationController refreshController;

  @override
  void initState() {
    refreshController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    Provider.of<ThermalPaperSizeProvider>(
      context,
      listen: false,
    ).getPrintModel();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dTexts = DTexts.instance;
    return ChangeNotifierProvider(
      create: (_) => FilePickerProvider(),
      child: Consumer2<FilePickerProvider, ThermalPaperSizeProvider>(
        builder: (context, fileModel, thermalPaperSizeProvider, child) {
          return Padding(
            padding: REdgeInsets.symmetric(horizontal: 100, vertical: 120),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: DColors.white,
                    spreadRadius: 5,
                    blurRadius: 3,
                    blurStyle: BlurStyle.solid,
                  ),
                ],
              ),
              child: fileModel.isDialogOpen
                  ? DAnimationLoaderWidget(
                      text: dTexts.convertingDocumentFile,
                      animation: DAnimation.convertAnimation,
                    )
                  : Column(
                      children: [
                        CommonPrinterHeaderSection(
                          titleText: "Thermal ${dTexts.selectDocument}",
                          selectedConnectivity:
                              thermalPaperSizeProvider.selectedConnectivity,
                          printModelList:
                              thermalPaperSizeProvider.printModelList,
                          selectedModelNo:
                              thermalPaperSizeProvider.selectedModelNo,
                          refreshController: refreshController,
                          onRefresh: () async {
                            await thermalPaperSizeProvider.refreshPrinterList();
                          },
                          onConnectivityChanged: (value) =>
                              thermalPaperSizeProvider.setConnectivity(
                                context,
                                value,
                              ),
                          onBluetoothTap: () async =>
                              await thermalPaperSizeProvider
                                  .showBluetoothListDialog(context),
                          onModelChanged: (value) {
                            if (value != null) {
                              thermalPrinterModelName = value;
                              thermalPaperSizeProvider
                                  .handlePrinterDeviceSelection(value);
                            }
                          },
                        ),
                        const SizedBox(height: DSizes.spaceBtwSections),

                        /// File Picker Icon
                        const Image(
                          width: 106,
                          height: 106,
                          image: AssetImage(DIcons.fileIcon),
                        ),
                        const SizedBox(height: 40),

                        /// Created Button Section
                        SizedBox(
                          width: 440,
                          height: 44,
                          child: FilledButton(
                            onPressed: fileModel.isProcessing
                                ? null
                                : () async {
                                    if (context
                                                .thermalPaperSizeProvider
                                                .selectedModelNo ==
                                            null ||
                                        context
                                            .thermalPaperSizeProvider
                                            .selectedModelNo!
                                            .isEmpty) {
                                      DSnackBar.warning(
                                        title: "Select Printer Model",
                                        message:
                                            "Please select a printer model.",
                                      );
                                      return;
                                    }
                                    await fileModel.pickFile(
                                      context: context,
                                      printType: thermalPrinter,
                                    );
                                  },
                            child: fileModel.isProcessing
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: ProgressRing(strokeWidth: 2),
                                  )
                                : Text(
                                    dTexts.selectFromFile,
                                    style: context.caption,
                                  ),
                          ),
                        ),
                        const SizedBox(height: DSizes.spaceBtwSections),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }
}

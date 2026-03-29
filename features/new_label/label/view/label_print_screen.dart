import 'dart:ui' as ui;
import 'app_bar/app_bar_option.dart';
import 'package:provider/provider.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'header_option/header_option.dart';
import '../provider/widget/text_provider.dart';
import '../provider/widget/shape_provider.dart';
import '../provider/multiple_widget_provider.dart';
import '../../../../common/custom_body/custom_body.dart';
import '../provider/common/common_function_provider.dart';
import 'package:grozziie/utils/constants/colors.dart';
import '../../../new_label/label/provider/widget/table_provider.dart';
import '../../../new_label/label/provider/widget/emoji_provider.dart';
import '../../../new_label/label/provider/widget/qr_code_provider.dart';
import '../../../new_label/label/provider/widget/barcode_provider.dart';
import 'package:grozziie/utils/extension/provider_extension.dart';
import '../../../new_label/label/provider/widget/image_take_provider.dart';
import 'package:grozziie/utils/constants/label_global_variable.dart';
import '../../../../common/print_settings/provider/printer_sdk_provider.dart';
import '../../../teamplated/local_templated/provider/local_templated_provider.dart';
import '../../../teamplated/server_teamplated/provider/server_teamplated_provider.dart';
import 'package:grozziie/features/new_label/label/provider/widget/line_provider.dart';
import 'package:grozziie/features/new_label/label/provider/widget/background_provider.dart';
import 'package:grozziie/features/new_label/label/view/dashboard_option/dashboard_option.dart';
import 'package:grozziie/features/new_label/label/provider/main_label/label_printer_provider.dart';

class LabelPrintScreen extends StatefulWidget {
  const LabelPrintScreen({
    super.key,
    this.mainContainerId,
    required this.paperWidth,
    required this.paperHeight,
    this.responsiveWidth,
    this.responsiveHeight,
    this.selectPlatform,
    this.printerType,
  });

  final int? mainContainerId;
  final int paperWidth;
  final int paperHeight;
  final String? selectPlatform;
  final String? printerType;
  final double? responsiveWidth;
  final double? responsiveHeight;

  @override
  State<LabelPrintScreen> createState() => _LabelPrintScreenState();
}

class _LabelPrintScreenState extends State<LabelPrintScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      selectPrinter = widget.printerType ?? '';
      mainPaperHeight = widget.paperHeight;
      mainPaperWidth = widget.paperWidth;
      context.labelPrinterProvider.paperWidth = widget.paperWidth;
      context.labelPrinterProvider.paperHeight = widget.paperHeight;
      context.labelPrinterProvider.calculateLabelDimensions(
        widget.paperWidth.toDouble(),
        widget.paperHeight.toDouble(),
      );
      Provider.of<PrinterSdkProvider>(context, listen: false).togglePrintSetting(false);
    });

    getLocalServerRetrieveFunction();
    super.initState();
  }

  Future<void> getLocalServerRetrieveFunction() async {
    if (widget.selectPlatform == localDatabase) {
      await context.localTeamplatedProvider.retrieveLocalAllWidgetContainers(widget.mainContainerId ?? 0);
    } else if (widget.selectPlatform == serverDatabase) {
      await Future.delayed(Duration(milliseconds: 10));

      if (!mounted) return;
      await context.serverTeamplatedProvider.retrieveAllWidgetContainers(
        widget.mainContainerId ?? 0,
        widget.responsiveWidth ?? 0,
        widget.responsiveHeight ?? 0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomBody(
      child: Consumer<LocalBackgroundProvider>(
        builder: (context, backgroundModel, child) {
          return Consumer<ServerTeamplatedProvider>(
            builder: (context, serverTemp, child) {
              return Consumer<MultipleWidgetProvider>(
                builder: (context, value, child) {
                  return Consumer<CommonFunctionProvider>(
                    builder: (context, commonModel, child) {
                      return Consumer<TextEditingProvider>(
                        builder: (context, textModel, child) {
                          return Consumer<BarcodeProvider>(
                            builder: (context, barcodeModel, child) {
                              return Consumer<QrCodeProvider>(
                                builder: (context, qrcodeModel, child) {
                                  return Consumer<ImageTakeProvider>(
                                    builder: (context, imageModel, child) {
                                      return Consumer<ShapeProvider>(
                                        builder: (context, shapeModel, child) {
                                          return Consumer<TableProvider>(
                                            builder: (context, tableModel, child) {
                                              return Consumer<LineProvide>(
                                                builder: (context, value, child) {
                                                  return Consumer<EmojiProvider>(
                                                    builder: (context, emojiModel, child) {
                                                      return Consumer<LabelPrinterProvider>(
                                                        builder: (context, printModel, child) {
                                                          return Consumer<LocalTeamplatedProvider>(
                                                            builder: (context, localTemp, child) {
                                                              return NavigationView(
                                                                appBar: NavigationAppBar(
                                                                  height: 70,
                                                                  backgroundColor: DColors.white,
                                                                  automaticallyImplyLeading: false,
                                                                  actions: AppBarOption(
                                                                    context: context,
                                                                    paperWidth: context.labelPrinterProvider.paperWidth,
                                                                    paperHeight:
                                                                        context.labelPrinterProvider.paperHeight,
                                                                    onPressed: () async {
                                                                      await commonModel.clearAllBorder();
                                                                      Future.delayed(
                                                                        const Duration(seconds: 1),
                                                                        () async {
                                                                          if (!context.mounted) return;
                                                                          ui.Image? saveBitmapImage = await printModel
                                                                              .convertWidgetToImage(
                                                                                context.labelPrinterProvider.paperWidth,
                                                                              );

                                                                          if (isAdmin) {
                                                                            if (!context.mounted) return;
                                                                            serverTemp.serverSaveInputDialog(
                                                                              context,
                                                                              saveBitmapImage!,
                                                                              context.labelPrinterProvider.paperWidth,
                                                                              context.labelPrinterProvider.paperHeight,
                                                                              widget.mainContainerId ?? 0,
                                                                              widget.selectPlatform ?? '',
                                                                              widget.printerType ?? '',
                                                                            );
                                                                          } else {
                                                                            if (!context.mounted) return;
                                                                            localTemp.localSaveInputDialog(
                                                                              context,
                                                                              saveBitmapImage!,
                                                                              context.labelPrinterProvider.paperWidth,
                                                                              context.labelPrinterProvider.paperHeight,
                                                                              widget.mainContainerId ?? 0,
                                                                              widget.selectPlatform ?? '',
                                                                              widget.printerType ?? '',
                                                                            );
                                                                          }
                                                                        },
                                                                      );
                                                                    },
                                                                  ),
                                                                ),

                                                                content: Container(
                                                                  color: Colors.grey[100],
                                                                  child: Column(
                                                                    children: [
                                                                      /// Header Section
                                                                      HeaderOption(
                                                                        context: context,
                                                                        labelPrintModel: printModel,
                                                                      ),

                                                                      /// DashBoard section
                                                                      DashboardOption(context: context),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                      );
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

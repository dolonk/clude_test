import 'package:provider/provider.dart';
import 'package:fluent_ui/fluent_ui.dart';

import '../../../../localization/main_texts.dart';
import '../provider/local_templated_provider.dart';
import '../../../../utils/snackbar_toast/snack_bar.dart';
import '../../../new_label/label/view/label_print_screen.dart';
import '../../../../utils/constants/label_global_variable.dart';
import '../../../../common/print_select_header/common_printer_header_section.dart';
import 'package:grozziie/utils/extension/provider_extension.dart';
import 'package:grozziie/utils/extension/text_extension.dart';
import '../../../new_label/printer_type/thermal/provider/thermal_paper_size_provider.dart';
import 'package:grozziie/features/teamplated/local_templated/view/widgets/templated_card.dart';

class ThermalLocalTemplated extends StatefulWidget {
  const ThermalLocalTemplated({super.key});

  @override
  State<ThermalLocalTemplated> createState() => _ThermalLocalTemplatedState();
}

class _ThermalLocalTemplatedState extends State<ThermalLocalTemplated>
    with SingleTickerProviderStateMixin {
  late AnimationController refreshController;

  @override
  void initState() {
    refreshController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    context.thermalPaperSizeProvider.getPrintModel();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<LocalTeamplatedProvider>(
        context,
        listen: false,
      ).loadData(printerType: thermalPrinter);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dTexts = DTexts.instance;
    return Consumer2<LocalTeamplatedProvider, ThermalPaperSizeProvider>(
      builder: (context, saveModel, thermalPaperSizeProvider, child) {
        return Column(
          children: [
            /// Print connect section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: CommonPrinterHeaderSection(
                titleText: "Thermal Templates",
                selectedConnectivity:
                    thermalPaperSizeProvider.selectedConnectivity,
                printModelList: thermalPaperSizeProvider.printModelList,
                selectedModelNo: thermalPaperSizeProvider.selectedModelNo,
                refreshController: refreshController,
                onRefresh: () async =>
                    await thermalPaperSizeProvider.refreshPrinterList(),
                onConnectivityChanged: (value) =>
                    thermalPaperSizeProvider.setConnectivity(context, value),
                onBluetoothTap: () async => await thermalPaperSizeProvider
                    .showBluetoothListDialog(context),
                onModelChanged: (value) {
                  if (value != null) {
                    thermalPrinterModelName = value;
                    thermalPaperSizeProvider.handlePrinterDeviceSelection(
                      value,
                    );
                  }
                },
              ),
            ),

            /// Template Card Section
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: saveModel.containers.length,
                itemBuilder: (context, index) {
                  final container = saveModel.containers[index];
                  return Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xffE6E6E6),
                          spreadRadius: 5,
                          blurRadius: 3,
                          blurStyle: BlurStyle.solid,
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        if (context.thermalPaperSizeProvider.selectedModelNo ==
                                null ||
                            context
                                .thermalPaperSizeProvider
                                .selectedModelNo!
                                .isEmpty) {
                          DSnackBar.warning(
                            title: dTexts.noPrinterFound,
                            message: dTexts.selectPrinter,
                          );
                          return;
                        }

                        Navigator.push(
                          context,
                          FluentPageRoute(
                            builder: (context) => LabelPrintScreen(
                              mainContainerId: container.id!,
                              paperWidth: container.containerWidth,
                              paperHeight: container.containerHeight,
                              selectPlatform: localDatabase,
                              printerType: thermalPrinter,
                            ),
                          ),
                        );
                      },
                      child: TemplateCard(
                        onDelete: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => ContentDialog(
                              title: Text(
                                dTexts.delete,
                                style: context.titleLarge,
                              ),
                              content: Text(
                                '${dTexts.areYouSureDelete} "${container.containerName}"?',
                                style: context.bodyLarge,
                              ),
                              actions: [
                                Button(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(dTexts.cancel),
                                  ),
                                  onPressed: () => Navigator.pop(ctx, false),
                                ),
                                FilledButton(
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all(
                                      Colors.red,
                                    ),
                                  ),
                                  child: Text(dTexts.delete),
                                  onPressed: () => Navigator.pop(ctx, true),
                                ),
                              ],
                            ),
                          );
                          if (confirmed == true && context.mounted) {
                            saveModel.deleteContainer(context, container.id!);
                          }
                        },
                        imageUrl: container.containerImageBitmapData!,
                        tName: container.containerName,
                        tWidth: container.containerWidth.toString(),
                        tHeight: container.containerHeight.toString(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }
}

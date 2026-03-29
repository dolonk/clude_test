import 'package:provider/provider.dart';
import 'package:fluent_ui/fluent_ui.dart';

import '../../../../localization/main_texts.dart';
import '../provider/local_templated_provider.dart';
import '../../../../utils/snackbar_toast/snack_bar.dart';
import '../../../new_label/label/view/label_print_screen.dart';
import '../../../../utils/constants/label_global_variable.dart';

import '../../../../common/print_select_header/common_printer_header_section.dart';
import 'package:grozziie/utils/extension/provider_extension.dart';
import 'package:grozziie/features/teamplated/local_templated/view/widgets/templated_card.dart';
import 'package:grozziie/features/new_label/printer_type/dot/provider/dot_paper_size_provider.dart';

class DotLocalTemplated extends StatefulWidget {
  const DotLocalTemplated({super.key});

  @override
  State<DotLocalTemplated> createState() => _DotLocalTemplatedState();
}

class _DotLocalTemplatedState extends State<DotLocalTemplated>
    with SingleTickerProviderStateMixin {
  late AnimationController refreshController;

  @override
  void initState() {
    refreshController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    context.dotPaperSizeProvider.getPrintModel();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<LocalTeamplatedProvider>(
        context,
        listen: false,
      ).loadData(printerType: dotPrinter);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dTexts = DTexts.instance;
    return Consumer2<LocalTeamplatedProvider, DotPaperSizeProvider>(
      builder: (context, saveModel, dotPaperSizeProvider, child) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: CommonPrinterHeaderSection(
                titleText: "Dot Templates",
                selectedConnectivity: dotPaperSizeProvider.selectedConnectivity,
                printModelList: dotPaperSizeProvider.printModelList,
                selectedModelNo: dotPaperSizeProvider.selectedModelNo,
                refreshController: refreshController,
                onRefresh: () async =>
                    await dotPaperSizeProvider.refreshPrinterList(),
                onConnectivityChanged: (value) =>
                    dotPaperSizeProvider.setConnectivity(context, value),
                onBluetoothTap: () async =>
                    await dotPaperSizeProvider.showBluetoothListDialog(context),
                onModelChanged: (value) {
                  if (value != null) {
                    dotPrinterModelName = value;
                    dotPaperSizeProvider.handlePrinterDeviceSelection(value);
                  }
                },
              ),
            ),
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
                      onTap: () {
                        if (context.dotPaperSizeProvider.selectedModelNo ==
                                null ||
                            context
                                .dotPaperSizeProvider
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
                              printerType: dotPrinter,
                            ),
                          ),
                        );
                      },
                      child: TemplateCard(
                        onDelete: () =>
                            saveModel.deleteContainer(context, container.id!),
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

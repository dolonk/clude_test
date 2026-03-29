import 'package:provider/provider.dart';
import 'package:fluent_ui/fluent_ui.dart';
import '../../../../localization/main_texts.dart';
import '../../../../utils/snackbar_toast/snack_bar.dart';
import '../../../new_label/label/view/label_print_screen.dart';
import '../../../../utils/constants/label_global_variable.dart';
import 'package:grozziie/utils/extension/text_extension.dart';
import 'package:grozziie/utils/extension/provider_extension.dart';
import '../../../../common/print_select_header/common_printer_header_section.dart';
import 'package:grozziie/features/teamplated/local_templated/view/widgets/templated_card.dart';
import 'package:grozziie/features/teamplated/server_teamplated/provider/server_teamplated_provider.dart';
import 'package:grozziie/features/new_label/printer_type/thermal/provider/thermal_paper_size_provider.dart';

class ThermalServerTemplated extends StatefulWidget {
  const ThermalServerTemplated({super.key});

  @override
  State<ThermalServerTemplated> createState() => _ThermalServerTemplatedState();
}

class _ThermalServerTemplatedState extends State<ThermalServerTemplated>
    with SingleTickerProviderStateMixin {
  late AnimationController refreshController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    refreshController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    context.thermalPaperSizeProvider.getPrintModel();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<ServerTeamplatedProvider>(
        context,
        listen: false,
      ).fetchData(printerType: thermalPrinter);
    });
    super.initState();
  }

  @override
  void dispose() {
    refreshController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dTexts = DTexts.instance;
    return Consumer2<ServerTeamplatedProvider, ThermalPaperSizeProvider>(
      builder: (context, saveModel, thermalPaperSizeProvider, child) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: CommonPrinterHeaderSection(
                titleText: "${dTexts.thermal} Templates",
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

            // filter categories and search
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 40,
              child: Row(
                children: [
                  Expanded(
                    child: Consumer<ServerTeamplatedProvider>(
                      builder: (context, provider, child) {
                        final categories = [
                          dTexts.all,
                          dTexts.general,
                          dTexts.retail,
                          dTexts.home,
                          dTexts.office,
                          dTexts.communication,
                        ];
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final isSelected =
                                provider.selectedCategoryIndex == index;
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: Button(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(
                                    isSelected ? Colors.blue : Colors.grey[30],
                                  ),
                                ),
                                onPressed: () {
                                  provider.updateSelectedIndex(
                                    index: index,
                                    printerType: thermalPrinter,
                                  );
                                },
                                child: Text(
                                  categories[index],
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    width: 250,
                    child: TextBox(
                      controller: _searchController,
                      prefix: const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Icon(FluentIcons.search),
                      ),
                      suffix: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(FluentIcons.clear, size: 12),
                              onPressed: () {
                                _searchController.clear();
                                Provider.of<ServerTeamplatedProvider>(
                                  context,
                                  listen: false,
                                ).searchLabels(
                                  printerType: thermalPrinter,
                                  query: "",
                                );
                                setState(() {});
                              },
                            )
                          : null,
                      placeholder: dTexts.searchTemplates,
                      onChanged: (value) {
                        Provider.of<ServerTeamplatedProvider>(
                          context,
                          listen: false,
                        ).searchLabels(
                          printerType: thermalPrinter,
                          query: value,
                        );
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: saveModel.isLoading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const ProgressRing(),
                          const SizedBox(height: 16),
                          Text(DTexts.instance.loading),
                        ],
                      ),
                    )
                  : saveModel.thermalFilteredDataList.isEmpty
                  ? Center(
                      child: Text(
                        "No data found",
                        style: context.bodyLarge.copyWith(color: Colors.grey),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 20,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                      itemCount: saveModel.thermalFilteredDataList.length,
                      itemBuilder: (context, index) {
                        final container =
                            saveModel.thermalFilteredDataList[index];
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
                              if (thermalPaperSizeProvider.selectedModelNo ==
                                      null ||
                                  thermalPaperSizeProvider
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
                                    selectPlatform: serverDatabase,
                                    paperWidth: container.containerWidth,
                                    paperHeight: container.containerHeight,
                                    responsiveWidth: container.responsiveWidth,
                                    responsiveHeight:
                                        container.responsiveHeight,
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
                                        onPressed: () =>
                                            Navigator.pop(ctx, false),
                                      ),
                                      FilledButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStateProperty.all(
                                                Colors.red,
                                              ),
                                        ),
                                        child: Text(dTexts.delete),
                                        onPressed: () =>
                                            Navigator.pop(ctx, true),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirmed == true && context.mounted) {
                                  saveModel.serverDeleteContainer(
                                    context,
                                    container.id!,
                                  );
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
}

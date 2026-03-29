import 'package:provider/provider.dart';
import 'package:fluent_ui/fluent_ui.dart';

import '../../../../localization/main_texts.dart';
import '../../../../utils/snackbar_toast/snack_bar.dart';
import '../../../new_label/label/view/label_print_screen.dart';
import '../../../../utils/constants/label_global_variable.dart';
import '../../../../common/print_select_header/common_printer_header_section.dart';
import 'package:grozziie/utils/extension/text_extension.dart';
import 'package:grozziie/utils/extension/provider_extension.dart';
import 'package:grozziie/features/teamplated/local_templated/view/widgets/templated_card.dart';
import 'package:grozziie/features/new_label/printer_type/dot/provider/dot_paper_size_provider.dart';
import 'package:grozziie/features/teamplated/server_teamplated/provider/server_teamplated_provider.dart';

class DotServerTemplated extends StatefulWidget {
  const DotServerTemplated({super.key});

  @override
  State<DotServerTemplated> createState() => _DotServerTemplatedState();
}

class _DotServerTemplatedState extends State<DotServerTemplated>
    with SingleTickerProviderStateMixin {
  late AnimationController refreshController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    refreshController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    context.dotPaperSizeProvider.getPrintModel();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<ServerTeamplatedProvider>(
        context,
        listen: false,
      ).fetchData(printerType: dotPrinter);
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
    return Consumer2<ServerTeamplatedProvider, DotPaperSizeProvider>(
      builder: (context, saveModel, dotPaperSizeProvider, child) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: CommonPrinterHeaderSection(
                titleText: "${dTexts.dotLabel} Templates",
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

            // Filter categories and search
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
                        return ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final isSelected =
                                provider.dotSelectedCategoryIndex == index;
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
                                    printerType: dotPrinter,
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
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 8),
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
                                  printerType: dotPrinter,
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
                        ).searchLabels(printerType: dotPrinter, query: value);
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
                  : saveModel.dotFilteredDataList.isEmpty
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
                      itemCount: saveModel.dotFilteredDataList.length,
                      itemBuilder: (context, index) {
                        final container = saveModel.dotFilteredDataList[index];
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
                              if (context
                                          .dotPaperSizeProvider
                                          .selectedModelNo ==
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
                                    selectPlatform: serverDatabase,
                                    paperWidth: container.containerWidth,
                                    paperHeight: container.containerHeight,
                                    responsiveWidth: container.responsiveWidth,
                                    responsiveHeight:
                                        container.responsiveHeight,
                                    printerType: dotPrinter,
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

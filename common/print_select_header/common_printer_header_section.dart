import 'package:fluent_ui/fluent_ui.dart';
import 'package:grozziie/common/print_select_header/common_label_paper_size.dart';
import 'package:grozziie/localization/main_texts.dart';
import 'package:grozziie/utils/constants/colors.dart';
import 'package:grozziie/utils/constants/sizes.dart';
import 'package:grozziie/utils/extension/text_extension.dart';
import 'package:grozziie/utils/snackbar_toast/snack_bar.dart';

class CommonPrinterHeaderSection extends StatelessWidget {
  const CommonPrinterHeaderSection({
    super.key,
    required this.titleText,
    required this.selectedConnectivity,
    required this.printModelList,
    required this.selectedModelNo,
    required this.refreshController,
    required this.onRefresh,
    required this.onConnectivityChanged,
    required this.onBluetoothTap,
    required this.onModelChanged,
  });

  /// The title text to display at the top of the header (e.g. Dot Label, Thermal Label)
  final String titleText;

  /// Current connectivity state ('USB' or 'Bluetooth')
  final String selectedConnectivity;

  /// List of raw PrintModel data
  final List<dynamic> printModelList;

  /// Selected model from printModelList
  final String? selectedModelNo;

  /// Controllers for Animations
  final AnimationController refreshController;

  /// Callbacks
  final Future<void> Function() onRefresh;
  final Function(String) onConnectivityChanged;
  final Future<void> Function() onBluetoothTap;
  final Function(String?) onModelChanged;

  @override
  Widget build(BuildContext context) {
    final dTexts = DTexts.instance;
    return Column(
      children: [
        /// Tittle Section
        CommonLabelPaperSize(
          tittleColor: DColors.primary.withValues(alpha: 0.2),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  titleText,
                  style: context.titleLarge.copyWith(color: DColors.primary),
                  textAlign: TextAlign.center,
                ),
              ),
              AnimatedBuilder(
                animation: refreshController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: refreshController.value * 6.3,
                    child: IconButton(
                      icon: const Icon(FluentIcons.refresh),
                      onPressed: () async {
                        refreshController.forward(from: 0);
                        await onRefresh();
                      },
                      style: ButtonStyle(iconSize: WidgetStateProperty.all(18)),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: DSizes.spaceBtwSections),

        /// Connectivity Section
        CommonLabelPaperSize(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(dTexts.selectConnectivity, style: context.bodyLarge.copyWith(color: DColors.primary)),
              const SizedBox(width: 30),

              // connectivity section
              Row(
                children: [
                  // usb
                  RadioButton(
                    checked: selectedConnectivity == 'USB',
                    onChanged: (value) => onConnectivityChanged('USB'),
                    content: Text(dTexts.usb, style: context.bodyLarge),
                  ),
                  const SizedBox(width: DSizes.spaceBtwItems),

                  // bluetooth
                  RadioButton(
                    checked: selectedConnectivity == 'Bluetooth',
                    onChanged: (value) => onConnectivityChanged('Bluetooth'),
                    content: Text(dTexts.bluetooth, style: context.bodyLarge),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: DSizes.spaceBtwSections),

        /// Select Printer Model Section
        CommonLabelPaperSize(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(dTexts.selectPrinterModel, style: context.bodyLarge.copyWith(color: DColors.primary)),
              selectedConnectivity == 'Bluetooth'
                  ? GestureDetector(
                      onTap: () async => await onBluetoothTap(),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: DColors.grey, width: 1.5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        child: Text(selectedModelNo?.toString() ?? dTexts.selectModel, style: context.bodyStrong),
                      ),
                    )
                  : printModelList.isEmpty
                  ? GestureDetector(
                      onTap: () {
                        DSnackBar.warning(title: dTexts.noPrinterFound, message: dTexts.selectPrinter);
                      },
                      child: AbsorbPointer(
                        child: ComboBox<String>(
                          value: null,
                          placeholder: Text(dTexts.selectModel, style: context.bodyStrong),
                          items: const [],
                          onChanged: (value) {},
                        ),
                      ),
                    )
                  : ComboBox<String>(
                      value: selectedModelNo,
                      placeholder: Text(dTexts.selectModel, style: context.bodyStrong),
                      items: printModelList.map((model) {
                        return ComboBoxItem<String>(
                          value: model.modelNo,
                          child: Text(model.modelNo ?? '', style: context.body),
                        );
                      }).toList(),
                      onChanged: (value) => onModelChanged(value),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}

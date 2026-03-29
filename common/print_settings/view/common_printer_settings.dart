import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:fluent_ui/fluent_ui.dart';
import '../../../utils/constants/sizes.dart';
import 'package:grozziie/localization/main_texts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/constants/label_global_variable.dart';
import '../../custom_edit_dropdown/custom_edit_drop_down.dart';
import 'package:grozziie/utils/extension/text_extension.dart';
import '../provider/common_sdk_variable.dart';
import 'package:grozziie/common/print_settings/provider/printer_sdk_provider.dart';

class CommonPrinterSettings extends StatefulWidget {
  const CommonPrinterSettings({super.key, required this.onPressed, required this.context});

  final BuildContext context;
  final VoidCallback onPressed;

  @override
  State<CommonPrinterSettings> createState() => _CommonPrinterSettingsState();
}

class _CommonPrinterSettingsState extends State<CommonPrinterSettings> {
  late String printerModelName = 'No Printer Selected';

  @override
  void initState() {
    if (selectPrinter == thermalPrinter) {
      printerModelName = thermalPrinterModelName;
    } else if (selectPrinter == dotPrinter) {
      printerModelName = dotPrinterModelName;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dTexts = DTexts.instance;

    return Consumer<PrinterSdkProvider>(
      builder: (context, printerModel, child) {
        return Column(
          children: [
            /// Printer name
            Row(
              children: [
                SizedBox(
                  width: 140.w,
                  child: Text(dTexts.model, style: context.bodyLarge),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(color: const Color(0xfff4f7f9), borderRadius: BorderRadius.circular(6)),
                    child: SizedBox(
                      height: 36,
                      child: Center(child: Text(printerModelName, style: context.bodyStrong)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: DSizes.spaceBtwItems),

            /// Printer Copy
            Row(
              children: [
                SizedBox(
                  width: 140.w,
                  child: Text(dTexts.printCopy, style: context.bodyLarge),
                ),
                Expanded(
                  child: Container(
                    height: 36,
                    decoration: BoxDecoration(color: const Color(0xfff4f7f9), borderRadius: BorderRadius.circular(6)),
                    child: Row(
                      children: [
                        // Printer copy text field
                        Expanded(
                          child: TextBox(
                            controller: isPrintSetting ? pPrinterCopy : lPrinterCopy,
                            maxLength: 3,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLines: 1,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            onChanged: (value) {
                              final newValue = int.tryParse(value);
                              if (newValue != null) {
                                if (isPrintSetting) {
                                  pCounter = newValue;
                                } else {
                                  lCounter = newValue;
                                }
                              }
                            },
                            style: context.bodyStrong,
                          ),
                        ),

                        // Increment/Decrement buttons
                        SizedBox(
                          width: 40,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(FluentIcons.chevron_up_med),
                                onPressed: () {
                                  if (isPrintSetting) {
                                    pCounter++;
                                    pPrinterCopy.text = pCounter.toString();
                                  } else {
                                    lCounter++;
                                    lPrinterCopy.text = lCounter.toString();
                                  }
                                },
                                style: ButtonStyle(
                                  iconSize: WidgetStateProperty.all(18),
                                  foregroundColor: WidgetStateProperty.all(Colors.grey),
                                  padding: WidgetStateProperty.all(const EdgeInsets.all(0)),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(FluentIcons.chevron_down_med),
                                onPressed: () {
                                  if (isPrintSetting) {
                                    if (pCounter > 1) {
                                      pCounter--;
                                      pPrinterCopy.text = pCounter.toString();
                                    }
                                  } else {
                                    if (lCounter > 1) {
                                      lCounter--;
                                      lPrinterCopy.text = lCounter.toString();
                                    }
                                  }
                                },
                                style: ButtonStyle(
                                  iconSize: WidgetStateProperty.all(18),
                                  foregroundColor: WidgetStateProperty.all(Colors.grey),
                                  padding: WidgetStateProperty.all(const EdgeInsets.all(0)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: DSizes.spaceBtwItems),

            /// Printer Speed
            Row(
              children: [
                SizedBox(
                  width: 140.w,
                  child: Text(dTexts.printSpeed, style: context.bodyLarge),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(color: const Color(0xfff4f7f9), borderRadius: BorderRadius.circular(6)),
                    child: SizedBox(
                      height: 36,
                      child: Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                (isPrintSetting ? pPrinterSpeed : lPrinterSpeed).toString(),
                                style: context.bodyStrong,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 40,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(FluentIcons.chevron_up_med),
                                  onPressed: () {
                                    if (isPrintSetting) {
                                      if (pPrinterSpeed < 6) {
                                        printerModel.setPrinterSpeed(pPrinterSpeed + 1);
                                      }
                                    } else {
                                      if (lPrinterSpeed < 6) {
                                        printerModel.setPrinterSpeed(lPrinterSpeed + 1);
                                      }
                                    }
                                  },
                                  style: ButtonStyle(
                                    iconSize: WidgetStateProperty.all(18),
                                    foregroundColor: WidgetStateProperty.all(Colors.grey),
                                    padding: WidgetStateProperty.all(const EdgeInsets.all(0)),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(FluentIcons.chevron_down_med),
                                  onPressed: () {
                                    if (isPrintSetting) {
                                      if (pPrinterSpeed > 1) {
                                        printerModel.setPrinterSpeed(pPrinterSpeed - 1);
                                      }
                                    } else {
                                      if (lPrinterSpeed > 1) {
                                        printerModel.setPrinterSpeed(lPrinterSpeed - 1);
                                      }
                                    }
                                  },
                                  style: ButtonStyle(
                                    iconSize: WidgetStateProperty.all(18),
                                    foregroundColor: WidgetStateProperty.all(Colors.grey),
                                    padding: WidgetStateProperty.all(const EdgeInsets.all(0)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: DSizes.spaceBtwItems),

            /// Printer Density
            Row(
              children: [
                // Print Density
                SizedBox(
                  width: 140.w,
                  child: Text(dTexts.printDensity, style: context.bodyLarge),
                ),

                // Custom Editable Dropdown for Print Density
                CustomEditableDropdown(
                  placeholder: "Select Density",
                  initialValue: (isPrintSetting ? pPrintDensity : lPrintDensity).toString(),
                  items: List.generate(10, (index) {
                    final value = index + 1;
                    return value.toString();
                  }),
                  defaultValue: "2",
                  onChanged: (value) {
                    final parsed = double.tryParse(value) ?? 0;
                    isPrintSetting ? pPrintDensity : lPrintDensity = parsed.toInt();
                    setState(() {});
                  },
                  onFieldSubmitted: (value) {
                    final newSize = int.parse(value);
                    if (newSize < 1 || newSize > 6) throw Exception();
                    setState(() => isPrintSetting ? pPrintDensity : lPrintDensity = newSize);
                  },
                ),
              ],
            ),
            const SizedBox(height: DSizes.spaceBtwItems),

            /// Printer Contrast
            Row(
              children: [
                SizedBox(
                  width: 140.w,
                  child: Text(dTexts.contrast, style: context.bodyLarge),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => printerModel.showFluentContrastDialog(context),
                    child: Container(
                      height: 36,
                      decoration: BoxDecoration(color: const Color(0xfff4f7f9), borderRadius: BorderRadius.circular(6)),
                      child: Center(
                        child: Text(
                          (isPrintSetting ? pPrinterContrastValue : lPrinterContrastValue).toString(),
                          style: context.bodyStrong,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: DSizes.defaultSpace),

            /// Print Button
            SizedBox(
              width: 200,
              height: 38,
              child: FilledButton(
                onPressed: widget.onPressed,
                child: Text(dTexts.print, style: context.bodyStrong.copyWith(color: Colors.white)),
              ),
            ),
          ],
        );
      },
    );
  }
}

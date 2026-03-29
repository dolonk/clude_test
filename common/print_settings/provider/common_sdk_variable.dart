import 'package:fluent_ui/fluent_ui.dart';

/// sdk global variable
bool isPrintSetting = false;
List<String?> modifiedPrinterNames = [];

/// Label print setting variable
int lCounter = 1;
int lPrinterSpeed = 1;
int lPrintDensity = 2;
int lPrinterContrastValue = 128;
TextEditingController lPrinterCopy = TextEditingController(text: '1');

/// Pdf print setting variable
int pCounter = 1;
int pPrinterSpeed = 1;
int pPrintDensity = 2;
int pPrinterContrastValue = 128;
TextEditingController pPrinterCopy = TextEditingController(text: '1');

import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import '../../common/clipboard_service/clipboard_service.dart';
import '../../common/print_settings/provider/printer_sdk_provider.dart';
import '../../common/redo_undo/undo_redo_manager.dart';
import '../../features/new_label/label/provider/common/common_function_provider.dart';
import '../../features/new_label/label/provider/widget/background_provider.dart';
import '../../features/new_label/label/provider/widget/line_provider.dart';
import '../../features/new_label/printer_type/thermal/provider/thermal_paper_size_provider.dart';
import '../../features/teamplated/local_templated/provider/local_templated_provider.dart';
import '../../features/document_section/common/pick_file_picker_provider.dart';
import '../../features/new_label/label/provider/multiple_widget_provider.dart';
import '../../features/new_label/label/provider/widget/barcode_provider.dart';
import '../../features/new_label/label/provider/widget/emoji_provider.dart';
import '../../features/new_label/label/provider/widget/qr_code_provider.dart';
import '../../features/new_label/label/provider/widget/shape_provider.dart';
import '../../features/new_label/label/provider/widget/table_provider.dart';
import '../../features/new_label/label/provider/widget/text_provider.dart';
import '../../features/new_label/label/provider/widget/image_take_provider.dart';
import '../../features/new_label/label/provider/main_label/label_printer_provider.dart';
import '../../features/new_label/printer_type/dot/provider/dot_paper_size_provider.dart';
import '../../features/teamplated/server_teamplated/provider/server_teamplated_provider.dart';
import '../../localization/provider/language_provider.dart';

extension Providers on BuildContext {
  /// GLOBAL PROVIDERS
  LanguageProvider get languageProvider => Provider.of<LanguageProvider>(this, listen: false);
  PrinterSdkProvider get printerSdkProvider => Provider.of<PrinterSdkProvider>(this, listen: false);

  /// LABEL SECTION PROVIDERS
  LabelPrinterProvider get labelPrinterProvider => Provider.of<LabelPrinterProvider>(this, listen: false);
  TextEditingProvider get textEditingProvider => Provider.of<TextEditingProvider>(this, listen: false);
  BarcodeProvider get barcodeProvider => Provider.of<BarcodeProvider>(this, listen: false);
  QrCodeProvider get qrCodeProvider => Provider.of<QrCodeProvider>(this, listen: false);
  ImageTakeProvider get imageTakeProvider => Provider.of<ImageTakeProvider>(this, listen: false);
  ShapeProvider get shapeProvider => Provider.of<ShapeProvider>(this, listen: false);
  EmojiProvider get emojiProvider => Provider.of<EmojiProvider>(this, listen: false);
  TableProvider get tableProvider => Provider.of<TableProvider>(this, listen: false);
  LineProvide get lineProvider => Provider.of<LineProvide>(this, listen: false);
  MultipleWidgetProvider get multipleWidgetProvider => Provider.of<MultipleWidgetProvider>(this, listen: false);
  LocalBackgroundProvider get localBackgroundProvider => Provider.of<LocalBackgroundProvider>(this, listen: false);

  // LABEL SECTION GLOBAL PROVIDERS
  CommonFunctionProvider get commonProvider => Provider.of<CommonFunctionProvider>(this, listen: false);
  GlobalUndoRedoManager get undoRedoProvider => Provider.of<GlobalUndoRedoManager>(this, listen: false);
  GlobalClipboardManager get copyPasteProvider => Provider.of<GlobalClipboardManager>(this, listen: false);
  LocalTeamplatedProvider get localTeamplatedProvider => Provider.of<LocalTeamplatedProvider>(this, listen: false);
  ServerTeamplatedProvider get serverTeamplatedProvider => Provider.of<ServerTeamplatedProvider>(this, listen: false);

  /// DOCUMENT SECTION PROVIDERS
  FilePickerProvider get filePickerProvider => Provider.of<FilePickerProvider>(this, listen: false);
  ThermalPaperSizeProvider get thermalPaperSizeProvider => Provider.of<ThermalPaperSizeProvider>(this, listen: false);
  DotPaperSizeProvider get dotPaperSizeProvider => Provider.of<DotPaperSizeProvider>(this, listen: false);
}

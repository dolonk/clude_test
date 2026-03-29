import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @pMessage.
  ///
  /// In en, this message translates to:
  /// **'Processing..Please wait.............. '**
  String get pMessage;

  /// No description provided for @inMessage.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection and try again.'**
  String get inMessage;

  /// No description provided for @getStart.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStart;

  /// No description provided for @newLabel.
  ///
  /// In en, this message translates to:
  /// **' Thermal Label'**
  String get newLabel;

  /// No description provided for @localTemplate.
  ///
  /// In en, this message translates to:
  /// **'Local Template'**
  String get localTemplate;

  /// No description provided for @documentPrint.
  ///
  /// In en, this message translates to:
  /// **'Thermal Document'**
  String get documentPrint;

  /// No description provided for @imagePrint.
  ///
  /// In en, this message translates to:
  /// **'Image Print'**
  String get imagePrint;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @selectPrinterModel.
  ///
  /// In en, this message translates to:
  /// **'Select Printer Model'**
  String get selectPrinterModel;

  /// No description provided for @selectModel.
  ///
  /// In en, this message translates to:
  /// **'Select Model'**
  String get selectModel;

  /// No description provided for @widthM.
  ///
  /// In en, this message translates to:
  /// **'Width(mm)'**
  String get widthM;

  /// No description provided for @heightM.
  ///
  /// In en, this message translates to:
  /// **'Height(mm)'**
  String get heightM;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @redo.
  ///
  /// In en, this message translates to:
  /// **'Redo'**
  String get redo;

  /// No description provided for @cut.
  ///
  /// In en, this message translates to:
  /// **'Cut'**
  String get cut;

  /// No description provided for @duplicated.
  ///
  /// In en, this message translates to:
  /// **'Duplicated'**
  String get duplicated;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @paste.
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get paste;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @labelSetup.
  ///
  /// In en, this message translates to:
  /// **'Label Setup'**
  String get labelSetup;

  /// No description provided for @rotate.
  ///
  /// In en, this message translates to:
  /// **'Rotate'**
  String get rotate;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @saveLocal.
  ///
  /// In en, this message translates to:
  /// **'Save Local'**
  String get saveLocal;

  /// No description provided for @enterTheModelName.
  ///
  /// In en, this message translates to:
  /// **'Enter The Model Name'**
  String get enterTheModelName;

  /// No description provided for @containerNameAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'Container Name Already Exists'**
  String get containerNameAlreadyExists;

  /// No description provided for @dataDoesNotSave.
  ///
  /// In en, this message translates to:
  /// **'Data does not Save'**
  String get dataDoesNotSave;

  /// No description provided for @dataSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Data Saved Successfully'**
  String get dataSavedSuccessfully;

  /// No description provided for @dataUpdateSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Data Update Successfully'**
  String get dataUpdateSuccessfully;

  /// No description provided for @templatedDeleteSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Templated Delete Successfully'**
  String get templatedDeleteSuccessfully;

  /// No description provided for @enterWidth.
  ///
  /// In en, this message translates to:
  /// **'Enter width(mm)'**
  String get enterWidth;

  /// No description provided for @enterHeight.
  ///
  /// In en, this message translates to:
  /// **'Enter Height(mm)'**
  String get enterHeight;

  /// No description provided for @invalidInput.
  ///
  /// In en, this message translates to:
  /// **'Invalid Input'**
  String get invalidInput;

  /// No description provided for @lErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Selected printer model more than paper Width and height'**
  String get lErrorMessage;

  /// No description provided for @labelSet.
  ///
  /// In en, this message translates to:
  /// **'Label Set'**
  String get labelSet;

  /// No description provided for @labelName.
  ///
  /// In en, this message translates to:
  /// **'Label Name'**
  String get labelName;

  /// No description provided for @zoom.
  ///
  /// In en, this message translates to:
  /// **'Zoom'**
  String get zoom;

  /// No description provided for @text.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get text;

  /// No description provided for @barcode.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get barcode;

  /// No description provided for @qrCode.
  ///
  /// In en, this message translates to:
  /// **'QrCode'**
  String get qrCode;

  /// No description provided for @image.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get image;

  /// No description provided for @shape.
  ///
  /// In en, this message translates to:
  /// **'Shape'**
  String get shape;

  /// No description provided for @emoji.
  ///
  /// In en, this message translates to:
  /// **'Emoji'**
  String get emoji;

  /// No description provided for @table.
  ///
  /// In en, this message translates to:
  /// **'Table'**
  String get table;

  /// No description provided for @content.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get content;

  /// No description provided for @textInputField.
  ///
  /// In en, this message translates to:
  /// **'Text Input Field'**
  String get textInputField;

  /// No description provided for @addField.
  ///
  /// In en, this message translates to:
  /// **'Add Field'**
  String get addField;

  /// No description provided for @fontStyle.
  ///
  /// In en, this message translates to:
  /// **'Font Style'**
  String get fontStyle;

  /// No description provided for @font.
  ///
  /// In en, this message translates to:
  /// **'Font'**
  String get font;

  /// No description provided for @size.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get size;

  /// No description provided for @align.
  ///
  /// In en, this message translates to:
  /// **'Align'**
  String get align;

  /// No description provided for @style.
  ///
  /// In en, this message translates to:
  /// **'Style'**
  String get style;

  /// No description provided for @barcodeInputField.
  ///
  /// In en, this message translates to:
  /// **'Barcode Input Field'**
  String get barcodeInputField;

  /// No description provided for @qrInputField.
  ///
  /// In en, this message translates to:
  /// **'Qr Input Field'**
  String get qrInputField;

  /// No description provided for @qRCodeStyle.
  ///
  /// In en, this message translates to:
  /// **'QRCode Style'**
  String get qRCodeStyle;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @automatic.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get automatic;

  /// No description provided for @eyeStyle.
  ///
  /// In en, this message translates to:
  /// **'Eye Style'**
  String get eyeStyle;

  /// No description provided for @dataModule.
  ///
  /// In en, this message translates to:
  /// **'Data Module'**
  String get dataModule;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @width.
  ///
  /// In en, this message translates to:
  /// **'Width'**
  String get width;

  /// No description provided for @shapeSize.
  ///
  /// In en, this message translates to:
  /// **'Shape size'**
  String get shapeSize;

  /// No description provided for @fixedFigureSize.
  ///
  /// In en, this message translates to:
  /// **'Fixed Figure Size'**
  String get fixedFigureSize;

  /// No description provided for @tableInputField.
  ///
  /// In en, this message translates to:
  /// **'Table Input Field'**
  String get tableInputField;

  /// No description provided for @tableRowOption.
  ///
  /// In en, this message translates to:
  /// **'Table Row Option'**
  String get tableRowOption;

  /// No description provided for @addRowAbove.
  ///
  /// In en, this message translates to:
  /// **'Add Row Above'**
  String get addRowAbove;

  /// No description provided for @addRowBelow.
  ///
  /// In en, this message translates to:
  /// **'Add Row Below'**
  String get addRowBelow;

  /// No description provided for @deleteRow.
  ///
  /// In en, this message translates to:
  /// **'Delete Row'**
  String get deleteRow;

  /// No description provided for @tableColumOption.
  ///
  /// In en, this message translates to:
  /// **'Table Colum Option'**
  String get tableColumOption;

  /// No description provided for @addColumLeft.
  ///
  /// In en, this message translates to:
  /// **'Add Colum Left'**
  String get addColumLeft;

  /// No description provided for @addColumRight.
  ///
  /// In en, this message translates to:
  /// **'Add Colum Right'**
  String get addColumRight;

  /// No description provided for @deleteColumn.
  ///
  /// In en, this message translates to:
  /// **'Delete Column'**
  String get deleteColumn;

  /// No description provided for @tableMergeOption.
  ///
  /// In en, this message translates to:
  /// **'Table Merge Option'**
  String get tableMergeOption;

  /// No description provided for @combineCell.
  ///
  /// In en, this message translates to:
  /// **'Combine cell'**
  String get combineCell;

  /// No description provided for @split.
  ///
  /// In en, this message translates to:
  /// **'Split'**
  String get split;

  /// No description provided for @tableStyle.
  ///
  /// In en, this message translates to:
  /// **'Table Style'**
  String get tableStyle;

  /// No description provided for @tableWidth.
  ///
  /// In en, this message translates to:
  /// **'Table width'**
  String get tableWidth;

  /// No description provided for @rowHeight.
  ///
  /// In en, this message translates to:
  /// **'Row Height'**
  String get rowHeight;

  /// No description provided for @columnWidth.
  ///
  /// In en, this message translates to:
  /// **'Column Width'**
  String get columnWidth;

  /// No description provided for @printSettings.
  ///
  /// In en, this message translates to:
  /// **'Print Settings'**
  String get printSettings;

  /// No description provided for @printCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get printCopy;

  /// No description provided for @printSpeed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get printSpeed;

  /// No description provided for @printDensity.
  ///
  /// In en, this message translates to:
  /// **'Density'**
  String get printDensity;

  /// No description provided for @contrast.
  ///
  /// In en, this message translates to:
  /// **'Contrast'**
  String get contrast;

  /// No description provided for @print.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get print;

  /// No description provided for @oK.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get oK;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @aspectRatio.
  ///
  /// In en, this message translates to:
  /// **'Aspect Ratio:'**
  String get aspectRatio;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @startP.
  ///
  /// In en, this message translates to:
  /// **'Start (P)'**
  String get startP;

  /// No description provided for @endP.
  ///
  /// In en, this message translates to:
  /// **'End (P)'**
  String get endP;

  /// No description provided for @paperPage.
  ///
  /// In en, this message translates to:
  /// **'Paper Page'**
  String get paperPage;

  /// No description provided for @rotationPage.
  ///
  /// In en, this message translates to:
  /// **'Rotation Page'**
  String get rotationPage;

  /// No description provided for @rotationP.
  ///
  /// In en, this message translates to:
  /// **'Rotation (P):'**
  String get rotationP;

  /// No description provided for @cropPdf.
  ///
  /// In en, this message translates to:
  /// **'Crop Pdf'**
  String get cropPdf;

  /// No description provided for @convertingDocumentFile.
  ///
  /// In en, this message translates to:
  /// **'Converting Document File'**
  String get convertingDocumentFile;

  /// No description provided for @selectDocument.
  ///
  /// In en, this message translates to:
  /// **'Select Document'**
  String get selectDocument;

  /// No description provided for @selectFromFile.
  ///
  /// In en, this message translates to:
  /// **'Select from file'**
  String get selectFromFile;

  /// No description provided for @printingPage.
  ///
  /// In en, this message translates to:
  /// **'Printing Page...'**
  String get printingPage;

  /// No description provided for @paperSize.
  ///
  /// In en, this message translates to:
  /// **'Paper Size'**
  String get paperSize;

  /// No description provided for @selectImageFile.
  ///
  /// In en, this message translates to:
  /// **'Select Image File'**
  String get selectImageFile;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get noInternetConnection;

  /// No description provided for @printerFound.
  ///
  /// In en, this message translates to:
  /// **'Printer Found'**
  String get printerFound;

  /// No description provided for @selectPrinter.
  ///
  /// In en, this message translates to:
  /// **'Select Printer'**
  String get selectPrinter;

  /// No description provided for @noPrinterFound.
  ///
  /// In en, this message translates to:
  /// **'No Printer Found'**
  String get noPrinterFound;

  /// No description provided for @connectedPrinter.
  ///
  /// In en, this message translates to:
  /// **'Connected to Printer.'**
  String get connectedPrinter;

  /// No description provided for @hMessage.
  ///
  /// In en, this message translates to:
  /// **'This printer model height more than paper size'**
  String get hMessage;

  /// No description provided for @languageSettings.
  ///
  /// In en, this message translates to:
  /// **'Language Settings'**
  String get languageSettings;

  /// No description provided for @unsupportedBarcodeType.
  ///
  /// In en, this message translates to:
  /// **'Unsupported Barcode Type'**
  String get unsupportedBarcodeType;

  /// No description provided for @selectContrastValue.
  ///
  /// In en, this message translates to:
  /// **'Select contrast value'**
  String get selectContrastValue;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @pdfWaringToast.
  ///
  /// In en, this message translates to:
  /// **'Their PDF page is more than 100 pages. Only open 100 pages'**
  String get pdfWaringToast;

  /// No description provided for @cancelPrinting.
  ///
  /// In en, this message translates to:
  /// **'Cancel Printing'**
  String get cancelPrinting;

  /// No description provided for @selectAutoSerialNumber.
  ///
  /// In en, this message translates to:
  /// **'Auto Serial Number'**
  String get selectAutoSerialNumber;

  /// No description provided for @prefix.
  ///
  /// In en, this message translates to:
  /// **'Prefix'**
  String get prefix;

  /// No description provided for @suffix.
  ///
  /// In en, this message translates to:
  /// **'Suffix'**
  String get suffix;

  /// No description provided for @increment.
  ///
  /// In en, this message translates to:
  /// **'Increment'**
  String get increment;

  /// No description provided for @startPage.
  ///
  /// In en, this message translates to:
  /// **'Start page'**
  String get startPage;

  /// No description provided for @endPage.
  ///
  /// In en, this message translates to:
  /// **'End page'**
  String get endPage;

  /// No description provided for @thermal.
  ///
  /// In en, this message translates to:
  /// **'Thermal'**
  String get thermal;

  /// No description provided for @dot.
  ///
  /// In en, this message translates to:
  /// **'Dot'**
  String get dot;

  /// No description provided for @dotLabel.
  ///
  /// In en, this message translates to:
  /// **'Dot Label'**
  String get dotLabel;

  /// No description provided for @selectConnectivity.
  ///
  /// In en, this message translates to:
  /// **'Select Connectivity'**
  String get selectConnectivity;

  /// No description provided for @bluetooth.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth'**
  String get bluetooth;

  /// No description provided for @usb.
  ///
  /// In en, this message translates to:
  /// **'USB'**
  String get usb;

  /// No description provided for @selectPaperSize.
  ///
  /// In en, this message translates to:
  /// **'Select Paper Size'**
  String get selectPaperSize;

  /// No description provided for @bluetoothPrinter.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth Printer'**
  String get bluetoothPrinter;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @model.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get model;

  /// No description provided for @dotDocument.
  ///
  /// In en, this message translates to:
  /// **'Dot Document'**
  String get dotDocument;

  /// No description provided for @selectPaper.
  ///
  /// In en, this message translates to:
  /// **'Select Paper'**
  String get selectPaper;

  /// No description provided for @scale.
  ///
  /// In en, this message translates to:
  /// **'Scale'**
  String get scale;

  /// No description provided for @page.
  ///
  /// In en, this message translates to:
  /// **'Page'**
  String get page;

  /// No description provided for @zoomPage.
  ///
  /// In en, this message translates to:
  /// **'Zoom Page'**
  String get zoomPage;

  /// No description provided for @saveData.
  ///
  /// In en, this message translates to:
  /// **'Save Data'**
  String get saveData;

  /// No description provided for @pageLoading.
  ///
  /// In en, this message translates to:
  /// **'Page Loading'**
  String get pageLoading;

  /// No description provided for @allPage.
  ///
  /// In en, this message translates to:
  /// **'All Page'**
  String get allPage;

  /// No description provided for @line.
  ///
  /// In en, this message translates to:
  /// **'Line'**
  String get line;

  /// No description provided for @lockMessageWaring.
  ///
  /// In en, this message translates to:
  /// **'Locked components are not supported'**
  String get lockMessageWaring;

  /// No description provided for @selectCell.
  ///
  /// In en, this message translates to:
  /// **'Select Table cell'**
  String get selectCell;

  /// No description provided for @addRowWaring.
  ///
  /// In en, this message translates to:
  /// **'Row insertion blocked: Invalid position in merged cell'**
  String get addRowWaring;

  /// No description provided for @addColumnWaring.
  ///
  /// In en, this message translates to:
  /// **'Column insertion blocked: Would break merged cell'**
  String get addColumnWaring;

  /// No description provided for @deleteRowWaring.
  ///
  /// In en, this message translates to:
  /// **'Cannot delete row: Would break merged cell'**
  String get deleteRowWaring;

  /// No description provided for @deleteColumnWaring.
  ///
  /// In en, this message translates to:
  /// **'Cannot delete column: Would break merged cell'**
  String get deleteColumnWaring;

  /// No description provided for @spaceWaring.
  ///
  /// In en, this message translates to:
  /// **'Need at least 2 widgets selected for spacing'**
  String get spaceWaring;

  /// No description provided for @simplifyPrinting.
  ///
  /// In en, this message translates to:
  /// **'Simplify printing'**
  String get simplifyPrinting;

  /// No description provided for @noPrinterDeviceFound.
  ///
  /// In en, this message translates to:
  /// **'No Printer Device Found!'**
  String get noPrinterDeviceFound;

  /// No description provided for @checkConnection.
  ///
  /// In en, this message translates to:
  /// **'Please check your USB connection or internet connection.'**
  String get checkConnection;

  /// No description provided for @bluetoothPrinters.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth Printers'**
  String get bluetoothPrinters;

  /// No description provided for @noPrintersFound.
  ///
  /// In en, this message translates to:
  /// **'No printers found.'**
  String get noPrintersFound;

  /// No description provided for @pairingDevice.
  ///
  /// In en, this message translates to:
  /// **'Pairing the device, pls wait...'**
  String get pairingDevice;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @cropYourImage.
  ///
  /// In en, this message translates to:
  /// **'Crop Your Image'**
  String get cropYourImage;

  /// No description provided for @lineType.
  ///
  /// In en, this message translates to:
  /// **'Line Type'**
  String get lineType;

  /// No description provided for @fontRotated.
  ///
  /// In en, this message translates to:
  /// **'Font Rotated'**
  String get fontRotated;

  /// No description provided for @serialNumber.
  ///
  /// In en, this message translates to:
  /// **'Serial Number'**
  String get serialNumber;

  /// No description provided for @dotPrinter.
  ///
  /// In en, this message translates to:
  /// **'Dot Printer'**
  String get dotPrinter;

  /// No description provided for @errorFetchingPrintModel.
  ///
  /// In en, this message translates to:
  /// **'Error fetching print model:'**
  String get errorFetchingPrintModel;

  /// No description provided for @alreadySelectedPrinter.
  ///
  /// In en, this message translates to:
  /// **'Already selected this printer model'**
  String get alreadySelectedPrinter;

  /// No description provided for @pleaseSelectPrinterModel.
  ///
  /// In en, this message translates to:
  /// **'Please select a printer model.'**
  String get pleaseSelectPrinterModel;

  /// No description provided for @pleaseSelectPaperSize.
  ///
  /// In en, this message translates to:
  /// **'Please select a valid paper size.'**
  String get pleaseSelectPaperSize;

  /// No description provided for @printerConnected.
  ///
  /// In en, this message translates to:
  /// **'Printer connected'**
  String get printerConnected;

  /// No description provided for @failedPairingPrinter.
  ///
  /// In en, this message translates to:
  /// **'Failed to pairing printer'**
  String get failedPairingPrinter;

  /// No description provided for @errorInitializingPdf.
  ///
  /// In en, this message translates to:
  /// **'Error Initializing PDF Files'**
  String get errorInitializingPdf;

  /// No description provided for @cannotRotate.
  ///
  /// In en, this message translates to:
  /// **'Can not rotated'**
  String get cannotRotate;

  /// No description provided for @missingWidthHeight.
  ///
  /// In en, this message translates to:
  /// **'Missing width/height controllers'**
  String get missingWidthHeight;

  /// No description provided for @invalidScaleValue.
  ///
  /// In en, this message translates to:
  /// **'Invalid scale value. Please enter a value between 1 and 4.'**
  String get invalidScaleValue;

  /// No description provided for @cropModeEnabledScale.
  ///
  /// In en, this message translates to:
  /// **'Crop mode is enabled. Please disable it to change the scale.'**
  String get cropModeEnabledScale;

  /// No description provided for @cropModeEnabledRotation.
  ///
  /// In en, this message translates to:
  /// **'Crop mode is enabled. Please disable it to change the rotation.'**
  String get cropModeEnabledRotation;

  /// No description provided for @areYouSureDelete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete'**
  String get areYouSureDelete;

  /// No description provided for @rotatedWidgetWarning.
  ///
  /// In en, this message translates to:
  /// **'Rotated widget cannot be added to multi-select'**
  String get rotatedWidgetWarning;

  /// No description provided for @status400.
  ///
  /// In en, this message translates to:
  /// **'Bad Request'**
  String get status400;

  /// No description provided for @status401.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized Access'**
  String get status401;

  /// No description provided for @status404.
  ///
  /// In en, this message translates to:
  /// **'Not Found'**
  String get status404;

  /// No description provided for @status409.
  ///
  /// In en, this message translates to:
  /// **'Conflict'**
  String get status409;

  /// No description provided for @status429.
  ///
  /// In en, this message translates to:
  /// **'Too Many Requests'**
  String get status429;

  /// No description provided for @status500.
  ///
  /// In en, this message translates to:
  /// **'Internal Server Error'**
  String get status500;

  /// No description provided for @guest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @administrator.
  ///
  /// In en, this message translates to:
  /// **'Administrator'**
  String get administrator;

  /// No description provided for @standardUser.
  ///
  /// In en, this message translates to:
  /// **'Standard User'**
  String get standardUser;

  /// No description provided for @confirmLogout.
  ///
  /// In en, this message translates to:
  /// **'Confirm Logout'**
  String get confirmLogout;

  /// No description provided for @areYouSureLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get areYouSureLogout;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get logIn;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Log in Failed. Please try again.'**
  String get loginFailed;

  /// No description provided for @adminLoginFailed.
  ///
  /// In en, this message translates to:
  /// **'Admin Log in Failed. Please try again.'**
  String get adminLoginFailed;

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration Failed. Please try again.'**
  String get registrationFailed;

  /// No description provided for @forgotPasswordSuccess.
  ///
  /// In en, this message translates to:
  /// **'Forgot password request successful!'**
  String get forgotPasswordSuccess;

  /// No description provided for @forgotPasswordFailed.
  ///
  /// In en, this message translates to:
  /// **'Forgot password request failed.'**
  String get forgotPasswordFailed;

  /// No description provided for @passwordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset successful!'**
  String get passwordResetSuccess;

  /// No description provided for @passwordResetFailed.
  ///
  /// In en, this message translates to:
  /// **'Password reset failed.'**
  String get passwordResetFailed;

  /// No description provided for @verificationResentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Verification resent successfully!'**
  String get verificationResentSuccess;

  /// No description provided for @verificationResentFailed.
  ///
  /// In en, this message translates to:
  /// **'Resending verification failed.'**
  String get verificationResentFailed;

  /// No description provided for @sendVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Send Verification Code'**
  String get sendVerificationCode;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCode;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @saveOnServer.
  ///
  /// In en, this message translates to:
  /// **'Save on server'**
  String get saveOnServer;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @updating.
  ///
  /// In en, this message translates to:
  /// **'Updating...'**
  String get updating;

  /// No description provided for @fileLocation.
  ///
  /// In en, this message translates to:
  /// **'File Location'**
  String get fileLocation;

  /// No description provided for @addImage.
  ///
  /// In en, this message translates to:
  /// **'Add Image'**
  String get addImage;

  /// No description provided for @printColor.
  ///
  /// In en, this message translates to:
  /// **'Print Color'**
  String get printColor;

  /// No description provided for @black.
  ///
  /// In en, this message translates to:
  /// **'Black'**
  String get black;

  /// No description provided for @background.
  ///
  /// In en, this message translates to:
  /// **'Background'**
  String get background;

  /// No description provided for @ansi.
  ///
  /// In en, this message translates to:
  /// **'ANSI'**
  String get ansi;

  /// No description provided for @square.
  ///
  /// In en, this message translates to:
  /// **'Square'**
  String get square;

  /// No description provided for @reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply;

  /// No description provided for @replyAll.
  ///
  /// In en, this message translates to:
  /// **'Reply all'**
  String get replyAll;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @serverTemplate.
  ///
  /// In en, this message translates to:
  /// **'Server Template'**
  String get serverTemplate;

  /// No description provided for @showData.
  ///
  /// In en, this message translates to:
  /// **'Show Data'**
  String get showData;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @chinese.
  ///
  /// In en, this message translates to:
  /// **'中文 (Chinese)'**
  String get chinese;

  /// No description provided for @internetConnectivityExample.
  ///
  /// In en, this message translates to:
  /// **'Internet Connectivity Example'**
  String get internetConnectivityExample;

  /// No description provided for @fontSizeMustBeNumber.
  ///
  /// In en, this message translates to:
  /// **'Font size must be a number between {min} and {max}.'**
  String fontSizeMustBeNumber(Object max, Object min);

  /// No description provided for @templateCategory.
  ///
  /// In en, this message translates to:
  /// **'Template Category'**
  String get templateCategory;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select a category'**
  String get selectCategory;

  /// No description provided for @saveDialogInstruction.
  ///
  /// In en, this message translates to:
  /// **'Choose a category and provide a name for your template to stay organized.'**
  String get saveDialogInstruction;

  /// No description provided for @updateServerTemplate.
  ///
  /// In en, this message translates to:
  /// **'Update Server Template'**
  String get updateServerTemplate;

  /// No description provided for @saveToCloudServer.
  ///
  /// In en, this message translates to:
  /// **'Save to Cloud Server'**
  String get saveToCloudServer;

  /// No description provided for @containerName.
  ///
  /// In en, this message translates to:
  /// **'Container Name'**
  String get containerName;

  /// No description provided for @containerNameExample.
  ///
  /// In en, this message translates to:
  /// **'e.g. My New Template'**
  String get containerNameExample;

  /// No description provided for @saveAs.
  ///
  /// In en, this message translates to:
  /// **'Save As'**
  String get saveAs;

  /// No description provided for @pleaseSelectContainerName.
  ///
  /// In en, this message translates to:
  /// **'Please select containerName'**
  String get pleaseSelectContainerName;

  /// No description provided for @searchTemplates.
  ///
  /// In en, this message translates to:
  /// **'Search templates...'**
  String get searchTemplates;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @retail.
  ///
  /// In en, this message translates to:
  /// **'Retail'**
  String get retail;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @office.
  ///
  /// In en, this message translates to:
  /// **'Office'**
  String get office;

  /// No description provided for @communication.
  ///
  /// In en, this message translates to:
  /// **'Communication'**
  String get communication;

  /// No description provided for @alignLeft.
  ///
  /// In en, this message translates to:
  /// **'Align Left'**
  String get alignLeft;

  /// No description provided for @alignRight.
  ///
  /// In en, this message translates to:
  /// **'Align Right'**
  String get alignRight;

  /// No description provided for @alignTop.
  ///
  /// In en, this message translates to:
  /// **'Align Top'**
  String get alignTop;

  /// No description provided for @alignBottom.
  ///
  /// In en, this message translates to:
  /// **'Align Bottom'**
  String get alignBottom;

  /// No description provided for @distributeVerticalTop.
  ///
  /// In en, this message translates to:
  /// **'Decrease Vertical Spacing'**
  String get distributeVerticalTop;

  /// No description provided for @distributeVerticalCenter.
  ///
  /// In en, this message translates to:
  /// **'Center Vertically'**
  String get distributeVerticalCenter;

  /// No description provided for @distributeVerticalBottom.
  ///
  /// In en, this message translates to:
  /// **'Increase Vertical Spacing'**
  String get distributeVerticalBottom;

  /// No description provided for @distributeHorizontalLeft.
  ///
  /// In en, this message translates to:
  /// **'Decrease Horizontal Spacing'**
  String get distributeHorizontalLeft;

  /// No description provided for @distributeHorizontalCenter.
  ///
  /// In en, this message translates to:
  /// **'Center Horizontally'**
  String get distributeHorizontalCenter;

  /// No description provided for @distributeHorizontalRight.
  ///
  /// In en, this message translates to:
  /// **'Increase Horizontal Spacing'**
  String get distributeHorizontalRight;

  /// No description provided for @lock.
  ///
  /// In en, this message translates to:
  /// **'Lock'**
  String get lock;

  /// No description provided for @unlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlock;

  /// No description provided for @multiSelect.
  ///
  /// In en, this message translates to:
  /// **'Multi Select'**
  String get multiSelect;

  /// No description provided for @zoomIn.
  ///
  /// In en, this message translates to:
  /// **'Zoom In'**
  String get zoomIn;

  /// No description provided for @zoomOut.
  ///
  /// In en, this message translates to:
  /// **'Zoom Out'**
  String get zoomOut;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

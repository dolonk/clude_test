import 'l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart';
import '../utils/extension/global_context.dart';

class DTexts {
  DTexts._();
  static final instance = DTexts._();
  BuildContext get context => GlobalContext.context!;

  /// Splash Screen
  String get pMessage => AppLocalizations.of(context)!.pMessage;
  String get inMessage => AppLocalizations.of(context)!.inMessage;
  String get getStart => AppLocalizations.of(context)!.getStart;
  String get simplifyPrinting => AppLocalizations.of(context)!.simplifyPrinting;

  /// ======================== SideBar Drawer Screen ====================================
  String get newLabel => AppLocalizations.of(context)!.newLabel;
  String get thermal => AppLocalizations.of(context)!.thermal;
  String get dotLabel => AppLocalizations.of(context)!.dotLabel;
  String get localTemplate => AppLocalizations.of(context)!.localTemplate;
  String get documentPrint => AppLocalizations.of(context)!.documentPrint;
  String get imagePrint => AppLocalizations.of(context)!.imagePrint;
  String get feedback => AppLocalizations.of(context)!.feedback;
  String get languageSettings => AppLocalizations.of(context)!.languageSettings;
  String get name => AppLocalizations.of(context)!.name;

  /// ================================== Label Section ==================================
  String get selectConnectivity =>
      AppLocalizations.of(context)!.selectConnectivity;
  String get bluetooth => AppLocalizations.of(context)!.bluetooth;
  String get usb => AppLocalizations.of(context)!.usb;
  String get selectPrinterModel =>
      AppLocalizations.of(context)!.selectPrinterModel;
  String get selectModel => AppLocalizations.of(context)!.selectModel;
  String get widthM => AppLocalizations.of(context)!.widthM;
  String get heightM => AppLocalizations.of(context)!.heightM;
  String get create => AppLocalizations.of(context)!.create;
  String get selectPaperSize => AppLocalizations.of(context)!.selectPaperSize;
  String get bluetoothPrinter => AppLocalizations.of(context)!.bluetoothPrinter;
  String get close => AppLocalizations.of(context)!.close;
  String get dotDocument => AppLocalizations.of(context)!.dotDocument;
  String get selectPaper => AppLocalizations.of(context)!.selectPaper;
  String get selectImageFile => AppLocalizations.of(context)!.selectImageFile;
  String get selectLanguage => AppLocalizations.of(context)!.selectLanguage;
  String get english => AppLocalizations.of(context)!.english;
  String get chinese => AppLocalizations.of(context)!.chinese;
  String get dotPrinterName => AppLocalizations.of(context)!.dotPrinter;
  String get areYouSureDelete => AppLocalizations.of(context)!.areYouSureDelete;

  //  Converting document to pdf
  String get convertingDocumentFile =>
      AppLocalizations.of(context)!.convertingDocumentFile;
  String get selectDocument => AppLocalizations.of(context)!.selectDocument;
  String get selectFromFile => AppLocalizations.of(context)!.selectFromFile;
  String get printingPage => AppLocalizations.of(context)!.printingPage;
  String get pdfWaringToast => AppLocalizations.of(context)!.pdfWaringToast;
  String get cancelPrinting => AppLocalizations.of(context)!.cancelPrinting;

  /// ================================================ TEMPLATE SCREEN =======================================
  // App Bar Screen
  String get save => AppLocalizations.of(context)!.save;
  String get undo => AppLocalizations.of(context)!.undo;
  String get redo => AppLocalizations.of(context)!.redo;
  String get cut => AppLocalizations.of(context)!.cut;
  String get duplicated => AppLocalizations.of(context)!.duplicated;
  String get copy => AppLocalizations.of(context)!.copy;
  String get paste => AppLocalizations.of(context)!.paste;
  String get delete => AppLocalizations.of(context)!.delete;
  String get labelSetup => AppLocalizations.of(context)!.labelSetup;
  String get rotate => AppLocalizations.of(context)!.rotate;
  String get update => AppLocalizations.of(context)!.update;

  // Header Screen
  String get labelName => AppLocalizations.of(context)!.labelName;
  String get zoom => AppLocalizations.of(context)!.zoom;

  // Save Data to Local and remote
  String get saveLocal => AppLocalizations.of(context)!.saveLocal;
  String get enterTheModelName =>
      AppLocalizations.of(context)!.enterTheModelName;
  String get containerNameAlreadyExists =>
      AppLocalizations.of(context)!.containerNameAlreadyExists;
  String get dataDoesNotSave => AppLocalizations.of(context)!.dataDoesNotSave;
  String get dataSavedSuccessfully =>
      AppLocalizations.of(context)!.dataSavedSuccessfully;
  String get dataUpdateSuccessfully =>
      AppLocalizations.of(context)!.dataUpdateSuccessfully;
  String get templatedDeleteSuccessfully =>
      AppLocalizations.of(context)!.templatedDeleteSuccessfully;
  String get enterWidth => AppLocalizations.of(context)!.enterWidth;
  String get enterHeight => AppLocalizations.of(context)!.enterHeight;
  String get invalidInput => AppLocalizations.of(context)!.invalidInput;
  String get lErrorMessage => AppLocalizations.of(context)!.lErrorMessage;
  String get labelSet => AppLocalizations.of(context)!.labelSet;

  // Clickable Button Container Screen
  String get text => AppLocalizations.of(context)!.text;
  String get barcode => AppLocalizations.of(context)!.barcode;
  String get qrCode => AppLocalizations.of(context)!.qrCode;
  String get table => AppLocalizations.of(context)!.table;
  String get image => AppLocalizations.of(context)!.image;
  String get emoji => AppLocalizations.of(context)!.emoji;
  String get shape => AppLocalizations.of(context)!.shape;
  String get line => AppLocalizations.of(context)!.line;

  // Text Input Field Screen
  String get content => AppLocalizations.of(context)!.content;
  String get textInputField => AppLocalizations.of(context)!.textInputField;
  String get addField => AppLocalizations.of(context)!.addField;
  String get fontStyle => AppLocalizations.of(context)!.fontStyle;
  String get font => AppLocalizations.of(context)!.font;
  String get size => AppLocalizations.of(context)!.size;
  String get align => AppLocalizations.of(context)!.align;
  String get style => AppLocalizations.of(context)!.style;

  // Barcode Data Input Container Screen
  String get barcodeInputField =>
      AppLocalizations.of(context)!.barcodeInputField;
  String get selectAutoSerialNumber =>
      AppLocalizations.of(context)!.selectAutoSerialNumber;
  String get prefix => AppLocalizations.of(context)!.prefix;
  String get suffix => AppLocalizations.of(context)!.suffix;
  String get increment => AppLocalizations.of(context)!.increment;
  String get startPage => AppLocalizations.of(context)!.startPage;
  String get endPage => AppLocalizations.of(context)!.endPage;
  String get unsupportedBarcodeType =>
      AppLocalizations.of(context)!.unsupportedBarcodeType;
  String get showData => AppLocalizations.of(context)!.showData;

  // QR Code Input Field Screen
  String get qrInputField => AppLocalizations.of(context)!.qrInputField;
  String get qRCodeStyle => AppLocalizations.of(context)!.qRCodeStyle;
  String get version => AppLocalizations.of(context)!.version;
  String get automatic => AppLocalizations.of(context)!.automatic;
  String get eyeStyle => AppLocalizations.of(context)!.eyeStyle;
  String get dataModule => AppLocalizations.of(context)!.dataModule;

  // Table Data Input Container Screen
  String get tableInputField => AppLocalizations.of(context)!.tableInputField;
  String get tableRowOption => AppLocalizations.of(context)!.tableRowOption;
  String get addRowAbove => AppLocalizations.of(context)!.addRowAbove;
  String get addRowBelow => AppLocalizations.of(context)!.addRowBelow;
  String get deleteRow => AppLocalizations.of(context)!.deleteRow;
  String get tableColumOption => AppLocalizations.of(context)!.tableColumOption;
  String get addColumLeft => AppLocalizations.of(context)!.addColumLeft;
  String get addColumRight => AppLocalizations.of(context)!.addColumRight;
  String get deleteColumn => AppLocalizations.of(context)!.deleteColumn;
  String get tableMergeOption => AppLocalizations.of(context)!.tableMergeOption;
  String get combineCell => AppLocalizations.of(context)!.combineCell;
  String get split => AppLocalizations.of(context)!.split;
  String get tableStyle => AppLocalizations.of(context)!.tableStyle;
  String get tableWidth => AppLocalizations.of(context)!.tableWidth;
  String get rowHeight => AppLocalizations.of(context)!.rowHeight;
  String get columnWidth => AppLocalizations.of(context)!.columnWidth;
  String get selectCell => AppLocalizations.of(context)!.selectCell;
  String get addRowWaring => AppLocalizations.of(context)!.addRowWaring;
  String get addColumnWaring => AppLocalizations.of(context)!.addColumnWaring;
  String get deleteRowWaring => AppLocalizations.of(context)!.deleteRowWaring;
  String get deleteColumnWaring =>
      AppLocalizations.of(context)!.deleteColumnWaring;

  // Shape Data Input Container Screen
  String get type => AppLocalizations.of(context)!.type;
  String get width => AppLocalizations.of(context)!.width;
  String get shapeSize => AppLocalizations.of(context)!.shapeSize;
  String get fixedFigureSize => AppLocalizations.of(context)!.fixedFigureSize;

  // Warning Message
  String get lockMessageWaring =>
      AppLocalizations.of(context)!.lockMessageWaring;
  String get spaceWaring => AppLocalizations.of(context)!.spaceWaring;
  String get lineType => AppLocalizations.of(context)!.lineType;
  String get fontRotated => AppLocalizations.of(context)!.fontRotated;
  String get serialNumber => AppLocalizations.of(context)!.serialNumber;
  String get cannotRotate => AppLocalizations.of(context)!.cannotRotate;
  String get rotatedWidgetWarning =>
      AppLocalizations.of(context)!.rotatedWidgetWarning;
  String fontSizeMustBeNumber({String min = '1', String max = '100'}) =>
      AppLocalizations.of(context)!.fontSizeMustBeNumber(min, max);

  /// ================================== COMMON PRINT SETTING ============================
  String get printSettings => AppLocalizations.of(context)!.printSettings;
  String get model => AppLocalizations.of(context)!.model;
  String get printCopy => AppLocalizations.of(context)!.printCopy;
  String get printSpeed => AppLocalizations.of(context)!.printSpeed;
  String get printDensity => AppLocalizations.of(context)!.printDensity;
  String get contrast => AppLocalizations.of(context)!.contrast;
  String get print => AppLocalizations.of(context)!.print;
  String get selectContrastValue =>
      AppLocalizations.of(context)!.selectContrastValue;
  String get noPrinterDeviceFound =>
      AppLocalizations.of(context)!.noPrinterDeviceFound;
  String get checkConnection => AppLocalizations.of(context)!.checkConnection;
  String get bluetoothPrinters =>
      AppLocalizations.of(context)!.bluetoothPrinters;
  String get noPrintersFound => AppLocalizations.of(context)!.noPrintersFound;
  String get pairingDevice => AppLocalizations.of(context)!.pairingDevice;
  String get errorFetchingPrintModel =>
      AppLocalizations.of(context)!.errorFetchingPrintModel;
  String get alreadySelectedPrinter =>
      AppLocalizations.of(context)!.alreadySelectedPrinter;
  String get pleaseSelectPrinterModel =>
      AppLocalizations.of(context)!.pleaseSelectPrinterModel;
  String get pleaseSelectPaperSize =>
      AppLocalizations.of(context)!.pleaseSelectPaperSize;
  String get printerConnected => AppLocalizations.of(context)!.printerConnected;
  String get failedPairingPrinter =>
      AppLocalizations.of(context)!.failedPairingPrinter;

  /// ================================== Document section section  ==================================
  // paper size
  String get paperSize => AppLocalizations.of(context)!.paperSize;
  String get aspectRatio => AppLocalizations.of(context)!.aspectRatio;
  String get zoomPage => AppLocalizations.of(context)!.zoomPage;
  String get saveData => AppLocalizations.of(context)!.saveData;
  // width text already have
  String get height => AppLocalizations.of(context)!.height;

  // paper page
  String get paperPage => AppLocalizations.of(context)!.paperPage;
  String get startP => AppLocalizations.of(context)!.startP;
  String get endP => AppLocalizations.of(context)!.endP;
  String get scale => AppLocalizations.of(context)!.scale;

  // rotated page
  String get rotationPage => AppLocalizations.of(context)!.rotationPage;
  String get rotationP => AppLocalizations.of(context)!.rotationP;

  // crop paper page
  String get oK => AppLocalizations.of(context)!.oK;
  String get cancel => AppLocalizations.of(context)!.cancel;
  String get allPage => AppLocalizations.of(context)!.allPage;
  String get cropPdf => AppLocalizations.of(context)!.cropPdf;
  String get cropYourImage => AppLocalizations.of(context)!.cropYourImage;

  String get page => AppLocalizations.of(context)!.page;
  String get pageLoading => AppLocalizations.of(context)!.pageLoading;
  String get errorInitializingPdf =>
      AppLocalizations.of(context)!.errorInitializingPdf;

  /// ==================================   Toaster Message  ====================================
  String get noInternetConnection =>
      AppLocalizations.of(context)!.noInternetConnection;
  String get printerFound => AppLocalizations.of(context)!.printerFound;
  String get selectPrinter => AppLocalizations.of(context)!.selectPrinter;
  String get noPrinterFound => AppLocalizations.of(context)!.noPrinterFound;
  String get connectedPrinter => AppLocalizations.of(context)!.connectedPrinter;
  String get hMessage => AppLocalizations.of(context)!.hMessage;
  String get missingWidthHeight =>
      AppLocalizations.of(context)!.missingWidthHeight;
  String get invalidScaleValue =>
      AppLocalizations.of(context)!.invalidScaleValue;
  String get cropModeEnabledScale =>
      AppLocalizations.of(context)!.cropModeEnabledScale;
  String get cropModeEnabledRotation =>
      AppLocalizations.of(context)!.cropModeEnabledRotation;

  /// ==================================   Auth & Dashboard  ====================================
  String get guest => AppLocalizations.of(context)!.guest;
  String get admin => AppLocalizations.of(context)!.admin;
  String get user => AppLocalizations.of(context)!.user;
  String get offline => AppLocalizations.of(context)!.offline;
  String get administrator => AppLocalizations.of(context)!.administrator;
  String get standardUser => AppLocalizations.of(context)!.standardUser;
  String get confirmLogout => AppLocalizations.of(context)!.confirmLogout;
  String get areYouSureLogout => AppLocalizations.of(context)!.areYouSureLogout;
  String get logOut => AppLocalizations.of(context)!.logOut;
  String get logIn => AppLocalizations.of(context)!.logIn;
  String get loginFailed => AppLocalizations.of(context)!.loginFailed;
  String get adminLoginFailed => AppLocalizations.of(context)!.adminLoginFailed;
  String get registrationFailed =>
      AppLocalizations.of(context)!.registrationFailed;
  String get forgotPasswordSuccess =>
      AppLocalizations.of(context)!.forgotPasswordSuccess;
  String get forgotPasswordFailed =>
      AppLocalizations.of(context)!.forgotPasswordFailed;
  String get passwordResetSuccess =>
      AppLocalizations.of(context)!.passwordResetSuccess;
  String get passwordResetFailed =>
      AppLocalizations.of(context)!.passwordResetFailed;
  String get verificationResentSuccess =>
      AppLocalizations.of(context)!.verificationResentSuccess;
  String get verificationResentFailed =>
      AppLocalizations.of(context)!.verificationResentFailed;
  String get sendVerificationCode =>
      AppLocalizations.of(context)!.sendVerificationCode;
  String get register => AppLocalizations.of(context)!.register;
  String get resetPassword => AppLocalizations.of(context)!.resetPassword;
  String get resendCode => AppLocalizations.of(context)!.resendCode;
  String get loading => AppLocalizations.of(context)!.loading;
  String get saveOnServer => AppLocalizations.of(context)!.saveOnServer;
  String get saving => AppLocalizations.of(context)!.saving;
  String get updating => AppLocalizations.of(context)!.updating;
  String get fileLocation => AppLocalizations.of(context)!.fileLocation;
  String get addImage => AppLocalizations.of(context)!.addImage;
  String get printColor => AppLocalizations.of(context)!.printColor;
  String get black => AppLocalizations.of(context)!.black;
  String get background => AppLocalizations.of(context)!.background;
  String get ansi => AppLocalizations.of(context)!.ansi;
  String get square => AppLocalizations.of(context)!.square;
  String get reply => AppLocalizations.of(context)!.reply;
  String get replyAll => AppLocalizations.of(context)!.replyAll;
  String get send => AppLocalizations.of(context)!.send;
  String get serverTemplate => AppLocalizations.of(context)!.serverTemplate;
  String get internetConnectivityExample =>
      AppLocalizations.of(context)!.internetConnectivityExample;

  /// Save Dialog
  String get templateCategory => AppLocalizations.of(context)!.templateCategory;
  String get selectCategory => AppLocalizations.of(context)!.selectCategory;
  String get saveDialogInstruction =>
      AppLocalizations.of(context)!.saveDialogInstruction;
  String get updateServerTemplate =>
      AppLocalizations.of(context)!.updateServerTemplate;
  String get saveToCloudServer =>
      AppLocalizations.of(context)!.saveToCloudServer;
  String get containerName => AppLocalizations.of(context)!.containerName;
  String get containerNameExample =>
      AppLocalizations.of(context)!.containerNameExample;
  String get saveAs => AppLocalizations.of(context)!.saveAs;
  String get pleaseSelectContainerName =>
      AppLocalizations.of(context)!.pleaseSelectContainerName;
  String get searchTemplates => AppLocalizations.of(context)!.searchTemplates;
  String get all => AppLocalizations.of(context)!.all;
  String get general => AppLocalizations.of(context)!.general;
  String get retail => AppLocalizations.of(context)!.retail;
  String get home => AppLocalizations.of(context)!.home;
  String get office => AppLocalizations.of(context)!.office;
  String get communication => AppLocalizations.of(context)!.communication;

  /// Tooltips
  String get alignLeft => AppLocalizations.of(context)!.alignLeft;
  String get alignRight => AppLocalizations.of(context)!.alignRight;
  String get alignTop => AppLocalizations.of(context)!.alignTop;
  String get alignBottom => AppLocalizations.of(context)!.alignBottom;
  String get distributeVerticalTop =>
      AppLocalizations.of(context)!.distributeVerticalTop;
  String get distributeVerticalCenter =>
      AppLocalizations.of(context)!.distributeVerticalCenter;
  String get distributeVerticalBottom =>
      AppLocalizations.of(context)!.distributeVerticalBottom;
  String get distributeHorizontalLeft =>
      AppLocalizations.of(context)!.distributeHorizontalLeft;
  String get distributeHorizontalCenter =>
      AppLocalizations.of(context)!.distributeHorizontalCenter;
  String get distributeHorizontalRight =>
      AppLocalizations.of(context)!.distributeHorizontalRight;
  String get lock => AppLocalizations.of(context)!.lock;
  String get unlock => AppLocalizations.of(context)!.unlock;
  String get multiSelect => AppLocalizations.of(context)!.multiSelect;
  String get zoomIn => AppLocalizations.of(context)!.zoomIn;
  String get zoomOut => AppLocalizations.of(context)!.zoomOut;
}

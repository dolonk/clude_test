import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import '../provider/printer_sdk_provider.dart';
import '../../../utils/constants/icons.dart';
import '../../../localization/main_texts.dart';
import '../../../utils/extension/global_context.dart';

/// Manager class to show/hide print loading overlay above all dialogs
class PrintLoadingOverlayManager {
  static OverlayEntry? _overlayEntry;
  static PrinterSdkProvider? _provider;

  /// Initialize the manager with provider listener - call once from app init
  static void init(BuildContext context) {
    // Prevent multiple initializations
    if (_provider != null) return;

    _provider = Provider.of<PrinterSdkProvider>(context, listen: false);
    _provider!.addListener(_handlePrintingStateChange);
  }

  static void _handlePrintingStateChange() {
    if (_provider == null) return;

    if (_provider!.isPrinting && _overlayEntry == null) {
      _showOverlay();
    } else if (!_provider!.isPrinting && _overlayEntry != null) {
      _hideOverlay();
    } else if (_provider!.isPrinting && _overlayEntry != null) {
      // Update the overlay (progress changed)
      _overlayEntry!.markNeedsBuild();
    }
  }

  static void _showOverlay() {
    final context = GlobalContext.navigatorKey.currentContext;
    if (context == null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => _PrintLoadingWidget(provider: _provider!),
    );

    final overlayState = Overlay.of(context, rootOverlay: true);
    overlayState.insert(_overlayEntry!);
  }

  static void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

/// The actual loading widget
class _PrintLoadingWidget extends StatelessWidget {
  final PrinterSdkProvider provider;

  const _PrintLoadingWidget({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(DIcons.loading, width: 100, height: 100),
              const SizedBox(height: 16),
              Text(
                DTexts.instance.printingPage,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${provider.currentPage} / ${provider.totalPages}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ProgressBar(
                value: provider.totalPages > 0
                    ? (provider.currentPage / provider.totalPages) * 100
                    : null,
              ),
              const SizedBox(height: 20),
              Button(
                onPressed: () {
                  provider.cancelPrinting();
                },
                child: Text(DTexts.instance.cancelPrinting),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Kept for backward compatibility - not used with OverlayEntry approach
class PrintLoadingOverlay extends StatelessWidget {
  final Widget child;
  const PrintLoadingOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Just initialize the manager and return child
    PrintLoadingOverlayManager.init(context);
    return child;
  }
}

import 'package:fluent_ui/fluent_ui.dart';
import 'package:grozziie/localization/main_texts.dart';
import 'package:grozziie/utils/constants/colors.dart';
import 'package:grozziie/utils/extension/text_extension.dart';
import 'package:grozziie/features/teamplated/server_teamplated/view/dot_server_teamplated.dart';
import 'package:grozziie/features/teamplated/server_teamplated/view/thermal_server_teamplated.dart';

class ServerTemplateTabView extends StatefulWidget {
  const ServerTemplateTabView({super.key});

  @override
  State<ServerTemplateTabView> createState() => _ServerTemplateTabViewState();
}

class _ServerTemplateTabViewState extends State<ServerTemplateTabView> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final dTexts = DTexts.instance;

    return Column(
      children: [
        /// Centered Tab Bar
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTab(
                index: 0,
                title: dTexts.thermal,
                icon: FluentIcons.print,
              ),
              const SizedBox(width: 16),
              _buildTab(
                index: 1,
                title: dTexts.dotLabel,
                icon: FluentIcons.page,
              ),
            ],
          ),
        ),

        /// Tab Content - Conditional rendering instead of IndexedStack
        Expanded(
          child: _currentIndex == 0
              ? const ThermalServerTemplated()
              : const DotServerTemplated(),
        ),
      ],
    );
  }

  Widget _buildTab({
    required int index,
    required String title,
    required IconData icon,
  }) {
    final isSelected = _currentIndex == index;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => setState(() => _currentIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? DColors.primary.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
            border: Border(
              bottom: BorderSide(
                color: isSelected ? DColors.primary : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? DColors.primary : DColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: context.bodyStrong.copyWith(
                  color: isSelected ? DColors.primary : DColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:fluent_ui/fluent_ui.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/icons.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

class CustomBody extends StatelessWidget {
  const CustomBody({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WindowTitleBarBox(
          child: Container(
            color: DColors.lSecondary,
            child: Row(
              children: [
                Expanded(
                  child: MoveWindow(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        DIcons.appLogo,
                        height: 50,
                        color: DColors.primary,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    MinimizeWindowButton(),
                    MaximizeWindowButton(),
                    CloseWindowButton(),
                  ],
                ),
              ],
            ),
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}

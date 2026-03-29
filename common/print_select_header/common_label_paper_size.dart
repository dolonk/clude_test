import 'package:fluent_ui/fluent_ui.dart';

class CommonLabelPaperSize extends StatelessWidget {
  final Widget child;
  final double height;
  final Color tittleColor;

  const CommonLabelPaperSize({
    super.key,
    required this.child,
    this.height = 44,
    this.tittleColor = const Color(0xFFF3F2F1),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: tittleColor, spreadRadius: 5, blurRadius: 3, blurStyle: BlurStyle.solid)],
      ),
      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0), child: child),
    );
  }
}

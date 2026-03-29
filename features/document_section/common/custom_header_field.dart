import 'package:fluent_ui/fluent_ui.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/colors.dart';
import 'package:grozziie/utils/extension/text_extension.dart';

class CustomHeaderField extends StatelessWidget {
  const CustomHeaderField({
    super.key,
    required this.hTittle,
    required this.child,
  });

  final String hTittle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Printer Size Tittle
          Text(hTittle, style: context.title.copyWith(color: DColors.primary)),
          const SizedBox(height: DSizes.spaceBtwSections),
          child,
        ],
      ),
    );
  }
}

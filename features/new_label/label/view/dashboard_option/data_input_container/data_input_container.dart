import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grozziie/features/new_label/label/view/dashboard_option/data_input_container/widgets/line_data_container/line_data_container.dart';
import '../../../../../../../utils/constants/label_global_variable.dart';
import 'package:grozziie/features/new_label/label/view/dashboard_option/data_input_container/widgets/barcode_data_input_container/barcode_data_input_container.dart';
import 'package:grozziie/features/new_label/label/view/dashboard_option/data_input_container/widgets/qr_data_input_container/qrcode_data_input_container.dart';
import 'package:grozziie/features/new_label/label/view/dashboard_option/data_input_container/widgets/shape_data_input_container/shape_data_input_container.dart';
import 'package:grozziie/features/new_label/label/view/dashboard_option/data_input_container/widgets/table_data_input_container/table_data_input_container.dart';
import 'package:grozziie/features/new_label/label/view/dashboard_option/data_input_container/widgets/text_data_input_container/text_data_input_container.dart';

class DataInputContainer extends StatelessWidget {
  const DataInputContainer({super.key, required this.context});

  final BuildContext context;

  Widget _chooseContainer() {
    if (showTextEditingContainerFlag) {
      return TextDataInputContainer(context: context);
    } else if (showBarcodeContainerFlag) {
      return BarcodeDataInputContainer(context: context);
    } else if (showQrcodeContainerFlag) {
      return QrcodeDataInputContainer(context: context);
    } else if (showShapeContainerFlag) {
      return ShapeDataInputContainer(context: context);
    } else if (showTableContainerFlag) {
      return TableDataInputContainer(context: context);
    } else if (showLineContainerFlag) {
      return LineDataInputContainer(context: context);
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400.w,
      color: Colors.white,
      child: SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(child: _chooseContainer()),
      ),
    );
  }
}

import 'package:cpad_assignment/ui/styles.dart';
import 'package:cpad_assignment/utility/size_config.dart';
import 'package:flutter/material.dart';
import 'package:cpad_assignment/ui/widgets/custom_outlined_button.dart';

class CustomErrorWidget extends StatelessWidget {
  final VoidCallback? onRefresh;

  CustomErrorWidget({this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.sentiment_dissatisfied_outlined,
          color: Colors.grey.shade500,
          size: 45,
        ),
        SizedBox(height: SizeConfig.blockSizeHorizontal * 3),
        Text(
          'Oops, something went wrong.',
          style: TextStyle(color: Colors.grey.shade500, fontSize: 18),
        ),
        SizedBox(height: SizeConfig.blockSizeHorizontal * 3),
        CustomOutlineButton(
          text: 'Refresh',
          outlineColor: kPrimaryColor,
          onPressed: onRefresh,
        )
      ],
    );
  }
}

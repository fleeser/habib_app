import 'package:flutter/material.dart';

import 'package:habib_app/core/common/widgets/hb_gap.dart';
import 'package:habib_app/core/res/theme/colors/hb_colors.dart';
import 'package:habib_app/core/res/theme/typography/hb_typography.dart';

class HBCheckbox extends StatelessWidget {

  final void Function(bool?)? onChanged; 
  final bool isSelected;
  final String text;

  const HBCheckbox({ 
    super.key,
    this.onChanged,
    this.isSelected = false,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: isSelected, 
          onChanged: onChanged,
          checkColor: HBColors.gray900,
          fillColor: const WidgetStatePropertyAll(HBColors.gray300),
          side: BorderSide.none,
        ),
        const HBGap.lg(),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: HBTypography.base.copyWith(
              color: HBColors.gray900,
              fontWeight: FontWeight.w400,
              fontSize: 14.0
            )
          )
        )
      ]
    );
  }
}
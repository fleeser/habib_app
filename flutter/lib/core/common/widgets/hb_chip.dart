import 'package:flutter/material.dart';

import 'package:habib_app/core/res/theme/spacing/hb_spacing.dart';
import 'package:habib_app/core/res/theme/typography/hb_typography.dart';

class HBChips extends StatelessWidget {

  final List<HBChip> chips;

  const HBChips({ 
    super.key,
    required this.chips
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.start,
      spacing: HBSpacing.md,
      runSpacing: HBSpacing.md,
      children: chips
    );
  }
}

class HBChip extends StatelessWidget {

  final String text;
  final Color color;
  final void Function()? onPressed;

  const HBChip({
    super.key,
    required this.text,
    required this.color,
    this.onPressed
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 30.0,
      child: RawMaterialButton(
        onPressed: onPressed,
        elevation: 0.0,
        focusElevation: 0.0,
        hoverElevation: 0.0,
        disabledElevation: 0.0,
        highlightElevation: 0.0,
        padding: const EdgeInsets.symmetric(horizontal: HBSpacing.md),
        fillColor: color.withOpacity(0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(
            width: 1.5,
            color: color
          )
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: HBTypography.base.copyWith(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            color: color
          )
        )
      )
    );
    
    
    /*Container(
      height: 30.0,
      padding: const EdgeInsets.symmetric(horizontal: HBSpacing.md),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withOpacity(0.4),
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
          width: 1.5,
          color: color
        )
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: HBTypography.base.copyWith(
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
          color: color
        )
      )
    )*/
  }
}
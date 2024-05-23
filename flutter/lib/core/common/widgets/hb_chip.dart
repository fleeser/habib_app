import 'package:flutter/material.dart';

import 'package:habib_app/core/res/theme/spacing/hb_spacing.dart';
import 'package:habib_app/core/res/theme/typography/hb_typography.dart';

class HBChip extends StatelessWidget {

  final String text;
  final Color color;

  const HBChip({
    super.key,
    required this.text,
    required this.color
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
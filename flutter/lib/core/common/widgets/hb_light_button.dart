import 'package:flutter/material.dart';

import 'package:habib_app/core/res/theme/colors/hb_colors.dart';
import 'package:habib_app/core/res/theme/typography/hb_typography.dart';

class HBLightButton extends StatelessWidget {

  final void Function()? onPressed;
  final bool isEnabled;
  final TextAlign? textAlign;
  final int maxLines;
  final TextOverflow overflow;
  final String title;

  const HBLightButton({ 
    super.key,
    this.onPressed,
    this.isEnabled = true,
    this.textAlign,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
    required this.title
  });

  void _onPressed() {
    if (isEnabled) {
      onPressed?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _onPressed,
        child: Text(
          title,
          maxLines: maxLines,
          overflow: overflow,
          style: HBTypography.base.copyWith(
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            color: HBColors.gray900,
            decoration: TextDecoration.underline
          )
        )
      )
    );
  }
}
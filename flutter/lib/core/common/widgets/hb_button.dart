import 'package:flutter/material.dart';

import 'package:habib_app/core/common/widgets/hb_gap.dart';
import 'package:habib_app/core/common/widgets/hb_icon.dart';
import 'package:habib_app/core/res/hb_icons.dart';
import 'package:habib_app/core/res/theme/colors/hb_colors.dart';
import 'package:habib_app/core/res/theme/spacing/hb_spacing.dart';
import 'package:habib_app/core/res/theme/typography/hb_typography.dart';
import 'package:habib_app/core/utils/constants/hb_ui_constants.dart';

class HBButton extends StatelessWidget {

  final void Function()? onPressed;
  final String? title;
  final HBIcons? icon;
  final bool isShrinked;
  final bool isOutlined;

  const HBButton.fill({
    super.key,
    this.onPressed,
    this.title,
    this.icon,
  })  : isShrinked = false,
        isOutlined = false;

  const HBButton.outline({
    super.key,
    this.onPressed,
    this.title,
    this.icon
  })  : isShrinked = false,
        isOutlined = true;

  const HBButton.shrinkFill({
    super.key,
    this.onPressed,
    this.title,
    this.icon,
  })  : isShrinked = true,
        isOutlined = false;

  const HBButton.shrinkOutline({
    super.key,
    this.onPressed,
    this.title,
    this.icon
  })  : isShrinked = true,
        isOutlined = true;

  @override
  Widget build(BuildContext context) {

    final double buttonHeight = isShrinked
      ? HBUIConstants.buttonShrinkedHeight
      : HBUIConstants.buttonHeight;
    
    return SizedBox(
      height: buttonHeight,
      width: isShrinked
        ? null
        : double.infinity,
      child: RawMaterialButton(
        onPressed: onPressed,
        fillColor: isOutlined
          ? null
          : HBColors.gray900,
        padding: const EdgeInsets.symmetric(horizontal: HBSpacing.lg),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(HBUIConstants.defaultBorderRadius),
          side: BorderSide(
            color: isOutlined
              ? HBColors.gray900
              : Colors.transparent,
            width: isOutlined
              ? 1.5
              : 0.0
          )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) HBIcon(
              icon: icon!, 
              size: buttonHeight * 0.5,
              color: isOutlined
                ? HBColors.gray900
                : HBColors.gray100
            ),
            if (icon != null && title != null) const HBGap.md(),
            if (title != null) Flexible(
              child: Text(
                title!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: HBTypography.base.copyWith(
                  fontSize: isShrinked
                    ? 14.0
                    : 16.0,
                  fontWeight: isShrinked
                    ? FontWeight.w400
                    : FontWeight.w600,
                  color: isOutlined
                    ? HBColors.gray900
                    : HBColors.gray100
                )
              )
            )
          ]
        )
      )
    );
  }
}
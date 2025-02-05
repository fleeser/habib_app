import 'package:flutter/material.dart';
import 'package:flutter_conditional/flutter_conditional.dart';
import 'package:habib_app/core/common/widgets/hb_gap.dart';

import 'package:habib_app/core/common/widgets/hb_icon.dart';
import 'package:habib_app/core/res/hb_icons.dart';
import 'package:habib_app/core/res/theme/colors/hb_colors.dart';
import 'package:habib_app/core/res/theme/spacing/hb_spacing.dart';
import 'package:habib_app/core/res/theme/typography/hb_typography.dart';
import 'package:habib_app/core/utils/constants/hb_ui_constants.dart';

class HBTextField extends StatelessWidget {

  final String? title;
  final TextEditingController? controller;
  final TextInputType? inputType;
  final HBIcons? icon;
  final String? hint;
  final bool obscure;
  final bool isEnabled;
  final double? maxWidth;
  final void Function(String)? onChanged;

  const HBTextField({
    this.title,
    super.key,
    this.controller,
    this.inputType,
    this.icon,
    this.hint,
    this.obscure = false,
    this.isEnabled = true,
    this.maxWidth,
    this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) Text(
            title!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: HBTypography.base.copyWith(
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
              color: HBColors.gray900
            )
          ),
          if (title != null) const HBGap.md(),
          TextField(
            controller: controller,
            onChanged: onChanged,
            autocorrect: false,
            enabled: isEnabled,
            keyboardType: inputType,
            canRequestFocus: isEnabled,
            obscureText: obscure,
            cursorColor: HBColors.gray900,
            style: HBTypography.base.copyWith(
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
              color: HBColors.gray900
            ),
            decoration: InputDecoration(
              fillColor: HBColors.gray200,
              filled: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: HBSpacing.md,
                vertical: (HBUIConstants.textFieldHeight - HBUIConstants.textFieldIconSize) / 2.0
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(HBUIConstants.defaultBorderRadius),
                borderSide: const BorderSide(
                  color: HBColors.gray400, 
                  width: 1.0
                )
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(HBUIConstants.defaultBorderRadius),
                borderSide: const BorderSide(
                  color: HBColors.gray400, 
                  width: 1.0
                )
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(HBUIConstants.defaultBorderRadius),
                borderSide: const BorderSide(
                  color: HBColors.gray400, 
                  width: 1.0
                )
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(HBUIConstants.defaultBorderRadius),
                borderSide: const BorderSide(
                  color: HBColors.gray400, 
                  width: 1.0
                )
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(HBUIConstants.defaultBorderRadius),
                borderSide: const BorderSide(
                  color: HBColors.gray900, 
                  width: 2.0
                )
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(HBUIConstants.defaultBorderRadius),
                borderSide: const BorderSide(
                  color: HBColors.gray900, 
                  width: 2.0
                )
              ),
              prefixIconConstraints: const BoxConstraints.tightFor(height: HBUIConstants.textFieldIconSize),
              prefixIcon: Conditional.optionalSingle(
                condition: icon != null,
                widget: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: HBSpacing.md),
                  child: HBIcon(
                    icon: icon!,
                    color: HBColors.gray500
                  )
                )
              ),
              hintText: hint,
              hintStyle: HBTypography.base.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
                color: HBColors.gray500
              )
            )
          )
        ]
      )
    );
  }
}
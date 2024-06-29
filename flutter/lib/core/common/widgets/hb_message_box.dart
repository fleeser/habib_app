import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_conditional/flutter_conditional.dart';
import 'package:go_router/go_router.dart';

import 'package:habib_app/core/common/widgets/hb_button.dart';
import 'package:habib_app/core/common/widgets/hb_gap.dart';
import 'package:habib_app/core/res/theme/colors/hb_colors.dart';
import 'package:habib_app/core/res/theme/spacing/hb_spacing.dart';
import 'package:habib_app/core/res/theme/typography/hb_typography.dart';
import 'package:habib_app/core/utils/constants/hb_ui_constants.dart';

Future<bool?> showHBMessageBox(
  BuildContext context, 
  String title, 
  String description, 
  String primaryButtonTitle, {
    FutureOr<bool> Function()? onPressed
  }
) async {
  return await showDialog<bool>(
    context: context, 
    builder: (BuildContext context) => HBMessageBox(
      title: title, 
      description: description,
      primaryButtonTitle: primaryButtonTitle,
      onPressed: onPressed
    )
  );
}

class HBMessageBox extends StatelessWidget {

  final String title;
  final String description;
  final String primaryButtonTitle;
  final FutureOr<bool> Function()? onPressed;

  const HBMessageBox({
    super.key,
    required this.title,
    required this.description,
    required this.primaryButtonTitle,
    this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0.0,
      insetPadding: const EdgeInsets.all(HBSpacing.lg),
      backgroundColor: HBColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(HBUIConstants.defaultBorderRadius)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400.0),
        child: Padding(
          padding: const EdgeInsets.all(HBSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: HBTypography.base.copyWith(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  color: HBColors.gray900
                )
              ),
              const HBGap.lg(),
              Text(
                description,
                textAlign: TextAlign.center,
                style: HBTypography.base.copyWith(
                  height: 1.5,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  color: HBColors.gray500
                )
              ),
              const HBGap.xl(),
              Row(
                children: [
                  Expanded(
                    child: HBMessageBoxButton(
                      onPressed: onPressed,
                      title: primaryButtonTitle
                    )
                  ),
                  const HBGap.md(),
                  const Expanded(child: HBMessageBoxButton.cancel())
                ]
              )
            ]
          )
        )
      )
    );
  }
}

class HBMessageBoxButton extends StatelessWidget {

  final FutureOr<bool> Function()? onPressed;
  final String title;
  final bool primary;

  const HBMessageBoxButton({
    super.key,
    this.onPressed,
    required this.title,
    this.primary = true
  });

  const HBMessageBoxButton.cancel({ super.key })
    : onPressed = null,
      title = 'Abbrechen',
      primary = false;

  Future<void> _handleOnPressed(BuildContext context) async {
    final bool shouldPop = await onPressed?.call() ?? true;
    if (context.mounted && context.canPop() && shouldPop) {
      final bool returnValue = onPressed != null ? shouldPop : false;
      context.pop(returnValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Conditional.single(
      condition: primary,
      widget: HBButton.fill(
        onPressed: () => _handleOnPressed(context),
        title: title
      ),
      fallback: HBButton.outline(
        onPressed: () => _handleOnPressed(context),
        title: title
      )
    );
  }
}
import 'package:flutter/material.dart';

import 'package:habib_app/core/common/widgets/hb_gap.dart';
import 'package:habib_app/core/common/widgets/hb_icon.dart';
import 'package:habib_app/core/extensions/context_extension.dart';
import 'package:habib_app/core/res/hb_icons.dart';
import 'package:habib_app/core/res/theme/colors/hb_colors.dart';
import 'package:habib_app/core/res/theme/spacing/hb_spacing.dart';
import 'package:habib_app/core/res/theme/typography/hb_typography.dart';
import 'package:habib_app/core/utils/constants/hb_ui_constants.dart';

class HBAppBar extends StatelessWidget implements PreferredSizeWidget {

  final BuildContext context;
  final List<HBAppBarButton> actionButtons;
  final HBAppBarBackButton? backButton;
  final String title;

  const HBAppBar({ 
    super.key,
    required this.context,
    this.backButton,
    required this.title,
    this.actionButtons = const <HBAppBarButton>[]
  });

  @override
  Size get preferredSize => Size.fromHeight(HBUIConstants.appBarHeight(context));

  @override
  Widget build(BuildContext context) {
    return Container(
      width: preferredSize.width,
      height: preferredSize.height,
      color: HBColors.white,
      padding: EdgeInsets.only(
        left: context.leftPadding + HBSpacing.lg,
        right: context.rightPadding + HBSpacing.lg,
        top: context.topPadding
      ),
      child: Row(
        children: [
          if (backButton != null) backButton!,
          if (backButton != null) const HBGap.md(),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: HBTypography.base.copyWith(
                fontSize: 22.0,
                fontWeight: FontWeight.w600,
                color: HBColors.gray900
              )
            )
          ),
          if (actionButtons.isNotEmpty) Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: List.generate(actionButtons.length, (int index) {
              return Padding(
                padding: EdgeInsets.only(
                  left: index != 0
                    ? HBSpacing.md
                    : 0.0
                ),
                child: actionButtons[index]
              );
            })
          )
        ]
      )
    );
  }
}

class HBAppBarButton extends StatelessWidget {

  final void Function()? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final HBIcons? icon;

  const HBAppBarButton({
    super.key,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.icon
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: HBUIConstants.appBarButtonSize,
      height: HBUIConstants.appBarButtonSize,
      child: RawMaterialButton(
        onPressed: onPressed,
        enableFeedback: !isLoading && isEnabled,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(HBUIConstants.appBarButtonSize / 2.0)),
        fillColor: HBColors.gray300,
        child: HBIcon(
          icon: icon!,
          color: HBColors.gray900,
          size: HBUIConstants.appBarButtonSize / 2.0
        )
      )
    );
  }
}

class HBAppBarBackButton extends StatelessWidget {

  final bool Function()? onPressed;
  final bool isLoading;
  final bool isEnabled;

  const HBAppBarBackButton({ 
    super.key,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: isEnabled && !isLoading,
      child: HBAppBarButton(
        onPressed: () => _onPressed(context),
        isLoading: isLoading,
        isEnabled: isEnabled,
        icon: HBIcons.arrowLeft
      )
    );
  }

  void _onPressed(BuildContext context) {
    if (!Navigator.of(context).canPop()) return;

    bool shouldPop = onPressed?.call() ?? true;
    if (!shouldPop) return;

    Navigator.of(context).pop();
  }
}
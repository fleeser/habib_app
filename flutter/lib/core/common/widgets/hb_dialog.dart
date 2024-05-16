import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:habib_app/core/common/widgets/hb_button.dart';
import 'package:habib_app/core/common/widgets/hb_gap.dart';
import 'package:habib_app/core/res/theme/colors/hb_colors.dart';
import 'package:habib_app/core/res/theme/spacing/hb_spacing.dart';
import 'package:habib_app/core/res/theme/typography/hb_typography.dart';
import 'package:habib_app/core/utils/constants/hb_ui_constants.dart';

class HBDialogPage<T> extends Page<T> {

  final Widget Function(BuildContext) builder;

  const HBDialogPage({ required this.builder });

  @override
  Route<T> createRoute(BuildContext context) {
    return DialogRoute<T>(
      settings: this,
      barrierDismissible: false,
      context: context, 
      builder: builder
    );
  }
}

class HBDialog<T> extends StatelessWidget {

  final String title;
  final List<Widget> children;
  final HBDialogActionButton? actionButton;

  const HBDialog({ 
    super.key,
    required this.title,
    this.children = const [],
    this.actionButton
  });

  void _cancel(BuildContext context) {
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0.0,
      insetPadding: const EdgeInsets.all(HBSpacing.lg),
      backgroundColor: HBColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(HBUIConstants.defaultBorderRadius)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 600.0,
          maxWidth: 800.0
        ),
        child: SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: HBSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: HBSpacing.lg),
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
                const HBGap.lg(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: HBSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: children
                    )
                  )
                ),
                const HBGap.lg(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: HBSpacing.lg),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (actionButton != null) HBButton.shrinkFill(
                        onPressed: actionButton!.onPressed,
                        title: actionButton!.title
                      ),
                      if (actionButton != null) const HBGap.md(),
                      HBButton.shrinkOutline(
                        onPressed: () => _cancel(context),
                        title: 'Abbrechen'
                      )
                    ]
                  )
                )
              ]
            )
          )
        )
      )
    );
  }
}

class HBDialogActionButton {

  final void Function()? onPressed;
  final String title;

  const HBDialogActionButton({
    this.onPressed,
    required this.title
  });
}

class HBDialogSection extends StatelessWidget {

  final String title;

  const HBDialogSection({
    super.key,
    required this.title
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: HBSpacing.xl,
        bottom: HBSpacing.lg
      ),
      child: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: HBTypography.base.copyWith(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          color: HBColors.gray900
        )
      )
    );
  }
}
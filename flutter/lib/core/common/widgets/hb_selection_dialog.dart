import 'package:flutter/material.dart';

import 'package:habib_app/core/common/widgets/hb_gap.dart';
import 'package:habib_app/core/res/theme/colors/hb_colors.dart';
import 'package:habib_app/core/res/theme/spacing/hb_spacing.dart';
import 'package:habib_app/core/res/theme/typography/hb_typography.dart';
import 'package:habib_app/core/utils/constants/hb_ui_constants.dart';

Future<T?> showHBSelectionDialog<T>({
  required BuildContext context,
  required String title,
  required Widget content
}) async {
  return await showDialog<T>(
    context: context, 
    builder: (BuildContext context) => HBSelectionDialog<T>(
      title: title,
      content: content
    )
  );
}

class HBSelectionDialog<T> extends StatelessWidget {

  final String title;
  final Widget content;

  const HBSelectionDialog({
    super.key,
    required this.title,
    required this.content
  });

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
                Expanded(child: content)
              ]
            )
          )
        )
      )
    );
  }
}
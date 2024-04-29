import 'package:flutter/material.dart';

import 'package:habib_app/core/common/widgets/hb_gap.dart';
import 'package:habib_app/core/common/widgets/hb_icon.dart';
import 'package:habib_app/core/extensions/context_extension.dart';
import 'package:habib_app/core/res/hb_icons.dart';
import 'package:habib_app/core/res/theme/colors/hb_colors.dart';
import 'package:habib_app/core/res/theme/spacing/hb_spacing.dart';
import 'package:habib_app/core/res/theme/typography/hb_typography.dart';
import 'package:habib_app/core/utils/constants/hb_ui_constants.dart';

class HBNavigationRail extends StatelessWidget {

  final int selectedIndex;
  final List<HBNavigationRailItem> items;
  final void Function(int)? onItemPressed;

  const HBNavigationRail({
    super.key,
    this.selectedIndex = 0,
    this.items = const [],
    this.onItemPressed
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: HBUIConstants.navigationRailWidth,
      height: double.infinity,
      color: HBColors.white,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: context.topPadding + HBSpacing.lg,
              left: context.leftPadding + HBSpacing.lg,
              right: HBSpacing.lg,
              bottom: HBSpacing.lg
            ),
            child: Text(
              'HABIB',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: HBTypography.base.copyWith(
                fontSize: 30.0,
                fontWeight: FontWeight.w900,
                color: HBColors.gray900
              )
            )
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: context.leftPadding + HBSpacing.lg,
                right: HBSpacing.lg,
                bottom: context.bottomPadding + HBSpacing.lg
              ),
              child: Column(
                children: List.generate(items.length, (int index) {

                  final HBNavigationRailItem item = items[index];
                  final bool isSelected = selectedIndex == index;

                  return Padding(
                    padding: EdgeInsets.only(
                      top: index != 0
                        ? HBSpacing.md
                        : 0.0
                    ),
                    child: SizedBox(
                      height: HBUIConstants.navigationRailButtonHeight,
                      width: double.infinity,
                      child: RawMaterialButton(
                        onPressed: () => onItemPressed?.call(index),
                        fillColor: isSelected
                          ? HBColors.gray900
                          : null,
                        padding: const EdgeInsets.symmetric(horizontal: HBSpacing.lg),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(HBUIConstants.defaultBorderRadius)),
                        child: Row(
                          children: [
                            HBIcon(
                              icon: item.icon, 
                              size: HBUIConstants.navigationRailButtonHeight * 0.4,
                              color: isSelected
                                ? HBColors.gray100
                                : HBColors.gray900
                            ),
                            const HBGap.lg(),
                            Expanded(
                              child: Text(
                                item.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: HBTypography.base.copyWith(
                                  fontSize: 16.0,
                                  fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                  color: isSelected
                                    ? HBColors.gray100
                                    : HBColors.gray900
                                )
                              )
                            )
                          ]
                        )
                      )
                    )
                  );
                })
              )
            )
          )
        ]
      )
    );
  }
}

class HBNavigationRailItem {

  final HBIcons icon;
  final String title;

  const HBNavigationRailItem({
    required this.icon,
    required this.title
  });
}
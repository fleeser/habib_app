import 'package:flutter/material.dart';

import 'package:flutter_conditional/flutter_conditional.dart';

import 'package:habib_app/core/res/theme/colors/hb_colors.dart';
import 'package:habib_app/core/res/theme/spacing/hb_spacing.dart';
import 'package:habib_app/core/res/theme/typography/hb_typography.dart';
import 'package:habib_app/core/utils/constants/hb_ui_constants.dart';

enum HBTableStatus {
  loading,
  text,
  data
}

class HBTable extends StatelessWidget {

  final HBTableStatus status;
  final EdgeInsets? padding;
  final ScrollController? controller;
  final double tableWidth;
  final int columnLength;
  final List<double> fractions;
  final List<String> titles;
  final List<List<String>> items;
  final String? text;
  final void Function(int index)? onPressed;

  const HBTable({
    super.key,
    required this.status,
    this.padding,
    this.controller,
    required this.tableWidth,
    required this.columnLength,
    required this.fractions,
    required this.titles,
    required this.items,
    this.text,
    this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: HBSpacing.lg + (padding?.left ?? 0.0),
            right: HBSpacing.lg + (padding?.right ?? 0.0),
            top: padding?.top ?? 0.0,
            bottom: HBSpacing.lg
          ),
          child: Row(
            children: List.generate(columnLength, (int columnIndex) {
              return HBTableTitle(
                width: tableWidth * fractions[columnIndex],
                title: titles[columnIndex]
              );
            })
          )
        ),
        Expanded(
          child: Conditional.multiCase(
            cases: [
              Case(
                condition: status == HBTableStatus.data,
                widget: ListView.builder(
                  controller: controller,
                  padding: EdgeInsets.only(
                    left: padding?.left ?? 0.0,
                    right: padding?.right ?? 0.0,
                    bottom: padding?.bottom ?? 0.0
                  ),
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int rowIndex) {
                    return SizedBox(
                      height: 50.0,
                      child: RawMaterialButton(
                        onPressed: () => onPressed?.call(rowIndex),
                        padding: const EdgeInsets.symmetric(horizontal: HBSpacing.lg),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(HBUIConstants.defaultBorderRadius)),
                        child: Row(
                          children: List.generate(columnLength, (int columnIndex) {
                            return HBTableText(
                              width: tableWidth * fractions[columnIndex],
                              text: items[rowIndex][columnIndex]
                            );
                          })
                        )
                      )
                    );
                  }
                )
              ),
              Case(
                condition: status == HBTableStatus.text,
                widget: Center(
                  child: Text(
                    text ?? '',
                    textAlign: TextAlign.center,
                    style: HBTypography.base.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: HBColors.gray900
                    )
                  )
                )
              )
            ]
          )
        )
      ]
    );
  }
}

class HBTableTitle extends StatelessWidget {

  final double width;
  final String title;

  const HBTableTitle({
    super.key,
    required this.width,
    required this.title
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: HBTypography.base.copyWith(
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
          color: HBColors.gray900
        )
      )
    );
  }
}

class HBTableText extends StatelessWidget {

  final double width;
  final String text;

  const HBTableText({
    super.key,
    required this.width,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: HBTypography.base.copyWith(
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
          color: HBColors.gray900
        )
      )
    );
  }
}
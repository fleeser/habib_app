import 'package:flutter/material.dart';

import 'package:flutter_conditional/flutter_conditional.dart';

import 'package:habib_app/core/common/widgets/hb_chip.dart';
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
  final List<List<HBTableItem>> items;
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
                            final HBTableItem item = items[rowIndex][columnIndex];
                            
                            return switch (item.type) {
                              HBTableItemType.text => SizedBox(
                                width: tableWidth * fractions[columnIndex],
                                child: item
                              ),
                              HBTableItemType.chip => item,
                              HBTableItemType.radioIndicator => item
                            };
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

enum HBTableItemType {
  text,
  chip,
  radioIndicator
}

class HBTableItem extends StatelessWidget {

  final HBTableItemType type;

  const HBTableItem({
    super.key,
    required this.type
  });
  
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

class HBTableText extends HBTableItem {

  final void Function()? onPressed;
  final String text;

  const HBTableText({
    super.key,
    this.onPressed,
    required this.text
  }) : super(type: HBTableItemType.text);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
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

class HBTableChip extends HBTableItem {

  final HBChip chip;

  const HBTableChip({ 
    super.key,
    required this.chip
  }) : super(type: HBTableItemType.chip);

  @override
  Widget build(BuildContext context) {
    return chip;
  }
}

class HBTableRadioIndicator extends HBTableItem {

  final bool isSelected;

  const HBTableRadioIndicator({ 
    super.key,
    required this.isSelected
  }) : super(type: HBTableItemType.radioIndicator);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20.0,
      height: 20.0,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: HBColors.gray900,
          width: 1.5
        )
      ),
      child: Conditional.optionalSingle(
        condition: isSelected,
        widget: Container(
          width: 12.0,
          height: 12.0,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: HBColors.gray900
          )
        )
      )
    );
  }
}
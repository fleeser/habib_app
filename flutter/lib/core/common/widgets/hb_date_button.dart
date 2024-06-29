import 'package:flutter/material.dart';

import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:flutter_conditional/flutter_conditional.dart';

import 'package:habib_app/core/common/widgets/hb_gap.dart';
import 'package:habib_app/core/extensions/datetime_extension.dart';
import 'package:habib_app/core/res/theme/colors/hb_colors.dart';
import 'package:habib_app/core/res/theme/spacing/hb_spacing.dart';
import 'package:habib_app/core/res/theme/typography/hb_typography.dart';
import 'package:habib_app/core/utils/constants/hb_ui_constants.dart';

Future<DateTime?> showHBDatePicker(
  BuildContext context, {
  String? title,
  DateTime? initialDateTime
}) async {

  return await showBoardDateTimePicker(
    context: context,
    pickerType: DateTimePickerType.date,
    initialDate: initialDateTime,
    options: BoardDateTimeOptions(
      languages: const BoardPickerLanguages(
        today: 'Heute',
        tomorrow: 'Morgen',
        locale: 'de'
      ),
      backgroundColor: HBColors.gray900,
      foregroundColor: HBColors.gray800,
      textColor: HBColors.gray100,
      activeColor: HBColors.gray100,
      activeTextColor: HBColors.gray900,
      startDayOfWeek: DateTime.monday,
      pickerFormat: PickerFormat.dmy,
      boardTitle: title,
      pickerSubTitles: const BoardDateTimeItemTitles(
        year: 'Jahr',
        month: 'Monat',
        day: 'Tag'
      )
    ),
    radius: HBUIConstants.defaultBorderRadius
  );
}

class HBDateButton extends StatelessWidget {

  final String title;
  final DateTime? dateTime;
  final bool isEnabled;
  final void Function(DateTime)? onChanged;
  final String? emptyText;

  const HBDateButton({
    super.key,
    required this.title,
    this.dateTime,
    this.isEnabled = true,
    this.onChanged,
    this.emptyText
  });

  Future<void> _handlePressed(context) async {
    DateTime? result = await showHBDatePicker(context);

    if (result != null) {
      onChanged?.call(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: HBTypography.base.copyWith(
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
            color: HBColors.gray900
          )
        ),
        const HBGap.md(),
        SizedBox(
          height: 52.0,
          width: double.infinity,
          child: RawMaterialButton(
            onPressed: () => _handlePressed(context),
            elevation: 0.0,
            focusElevation: 0.0,
            highlightElevation: 0.0,
            hoverElevation: 0.0,
            enableFeedback: isEnabled,
            fillColor: HBColors.gray200,
            padding: const EdgeInsets.symmetric(horizontal: HBSpacing.md),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(HBUIConstants.defaultBorderRadius)),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Conditional.single(
                condition: dateTime == null,
                widget: Text(
                  emptyText ?? '',
                  style: HBTypography.base.copyWith(
                    color: HBColors.gray500,
                    fontWeight: FontWeight.w400,
                    fontSize: 14.0
                  )
                ),
                fallback: Text(
                  dateTime?.toHumanReadableDate() ?? '',
                  style: HBTypography.base.copyWith(
                    color: HBColors.gray900,
                    fontWeight: FontWeight.w400,
                    fontSize: 16.0
                  )
                )
              )
            )
          )
        )
      ]
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:toastification/toastification.dart';

import 'package:habib_app/core/res/theme/typography/hb_typography.dart';
import 'package:habib_app/core/res/theme/colors/hb_colors.dart';
import 'package:habib_app/core/utils/constants/hb_ui_constants.dart';
import 'package:habib_app/core/utils/enums/toast_type.dart';
import 'package:habib_app/core/res/theme/spacing/hb_spacing.dart';

abstract class CoreUtils {

  const CoreUtils();

  static void postFrameCall(VoidCallback callback) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  static void showToast(
    BuildContext context, 
  { 
    required ToastType type,
    required String title,
    required String description
  }) {
    postFrameCall(() {
      toastification.show(
        context: context,
        type: type.toastificationType,
        borderRadius: BorderRadius.circular(HBUIConstants.defaultBorderRadius),
        padding: const EdgeInsets.all(HBSpacing.lg),
        foregroundColor: HBColors.white,
        backgroundColor: type.backgroundColor(context),
        title: Text(
          title,
          style: HBTypography.base.copyWith(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: HBColors.white
          )
        ),
        description: Text(
          description,
          style: HBTypography.base.copyWith(
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            color: HBColors.white
          )
        ),
        style: ToastificationStyle.fillColored,
        autoCloseDuration: const Duration(seconds: 3)
      );
    });
  }
}
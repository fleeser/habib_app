import 'package:flutter/material.dart';

import 'package:toastification/toastification.dart';

import 'package:habib_app/core/res/theme/colors/hb_colors.dart';

enum ToastType {

  info(ToastificationType.info),
  success(ToastificationType.success),
  warning(ToastificationType.warning),
  error(ToastificationType.error);

  final ToastificationType toastificationType;

  const ToastType(this.toastificationType);

  Color backgroundColor(BuildContext context) {
    return switch (this) {
      ToastType.info => HBColors.blue500,
      ToastType.success => HBColors.green500,
      ToastType.warning => HBColors.orange500,
      ToastType.error => HBColors.red500
    };
  }
}
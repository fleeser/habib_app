import 'package:flutter/material.dart';

import 'package:habib_app/core/extensions/context_extension.dart';

class HBUIConstants {

  static const double navigationRailWidth = 280.0;
  static const double navigationRailButtonHeight = 52.0;

  static double appBarHeight(BuildContext context) => context.topPadding + kToolbarHeight;
  static const double appBarButtonSize = kToolbarHeight - 8.0;

  static const double textFieldHeight = 52.0;
  static const double textFieldButtonSize = 48.0;
  static const double textFieldIconSize = 26.0;

  static const double buttonHeight = 52.0;
  static const double buttonShrinkedHeight = 42.0;

  static const double defaultBorderRadius = 12.0;
}
import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  Size get size => MediaQuery.sizeOf(this);
  double get height => size.height;
  double get width => size.width;

  EdgeInsets get padding => MediaQuery.paddingOf(this);
  double get leftPadding => padding.left;
  double get topPadding => padding.top;
  double get rightPadding => padding.right;
  double get bottomPadding => padding.bottom;
}
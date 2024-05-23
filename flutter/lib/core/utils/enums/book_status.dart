import 'package:flutter/material.dart';
import 'package:habib_app/core/res/theme/colors/hb_colors.dart';

enum BookStatus {

  available('Erhältlich', HBColors.green500, 1),
  borrowed('Verliehen', HBColors.red500, 0);

  final String title;
  final Color color;
  final int databaseValue;

  const BookStatus(this.title, this.color, this.databaseValue);

  static fromDatabaseValue(int value) => BookStatus.values.firstWhere((BookStatus status) => status.databaseValue == value);
}
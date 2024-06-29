import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:toastification/toastification.dart';

import 'package:habib_app/core/utils/typedefs.dart';
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

  static String sqlSearchTextFromText(String searchText) {
    final List<String> list = searchText.split(' ');
    String res = '';

    for (String listItem in list) {
      if (res.isNotEmpty) res += ' AND ';
      res += "x.cf_search LIKE '%${ listItem.toLowerCase() }%'";
    }

    return res;
  }

  static String sqlCreateTextFromJson({
    required String table,
    required Json json
  }) {
    return 'INSERT INTO $table (${ json.keys.join(', ') }) VALUES (${ json.values.join(', ') })';
  }

  static String sqlUpdateTextFromJson({ 
    required String table, 
    required Json json,
    String? where
  }) {
    String res = 'UPDATE $table SET ';

    for (int i = 0; i < json.entries.length; i++) {
      final MapEntry<String, dynamic> entry = json.entries.elementAt(i);
      res += '$table.${ entry.key } = ${ entry.value }';
      if (i != json.entries.length - 1) {
        res += ', ';
      }
    }
    
    if (where != null) res += ' WHERE $where';

    return res;
  }

  static String sqlListCreateTextFromJson({
    required String table,
    required List<String> columns,
    required List<List<dynamic>> values
  }) {
    String res = 'INSERT INTO $table (${ columns.join(', ') }) VALUES ';
    
    res += values.map((e) => '(${ e.join(', ') })').join(', ');

    return res;
  }

  static String textFromMonth(int number) {
    return switch (number) {
      1 => 'JAN',
      2 => 'FEB',
      3 => 'MÄR',
      4 => 'APR',
      5 => 'MAI',
      6 => 'JUN',
      7 => 'JUL',
      8 => 'AUG',
      9 => 'SEP',
      10 => 'OKT',
      11 => 'NOV',
      12 => 'DEZ',
      _ => throw ArgumentError('Month not found for number: $number')
    };
  }

  static (List<int> list1, List<int> list2) findUniqueElements(List<int> list1, List<int> list2) {
    Set<int> set1 = list1.toSet();
    Set<int> set2 = list2.toSet();

    List<int> onlyInList1 = set1.difference(set2).toList();
    List<int> onlyInList2 = set2.difference(set1).toList();

    return (onlyInList1, onlyInList2);
  }

  static bool intListsHaveSameContents(List<int> list1, List<int> list2) {
    Set<int> set1 = list1.toSet();
    Set<int> set2 = list2.toSet();

    return set1 == set2;
  }
}
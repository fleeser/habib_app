import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:habib_app/core/common/widgets/hb_app_bar.dart';
import 'package:habib_app/core/res/theme/colors/hb_colors.dart';

class HBScaffold extends StatelessWidget {

  final HBAppBar? appBar;
  final Widget? body;

  const HBScaffold({ 
    super.key,
    this.appBar,
    this.body
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: HBColors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: HBColors.white,
        statusBarColor: HBColors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark
      ),
      child: Scaffold(
        backgroundColor: HBColors.white,
        appBar: appBar,
        body: body
      )
    );
  }
}
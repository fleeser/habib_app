import 'package:flutter/material.dart';

import 'package:habib_app/core/common/widgets/hb_app_bar.dart';
import 'package:habib_app/core/common/widgets/hb_gap.dart';
import 'package:habib_app/core/common/widgets/hb_icon.dart';
import 'package:habib_app/core/common/widgets/hb_scaffold.dart';
import 'package:habib_app/core/common/widgets/sc_text_field.dart';
import 'package:habib_app/core/extensions/context_extension.dart';
import 'package:habib_app/core/res/hb_icons.dart';
import 'package:habib_app/core/res/theme/colors/hb_colors.dart';
import 'package:habib_app/core/res/theme/spacing/hb_spacing.dart';
import 'package:habib_app/core/utils/constants/hb_ui_constants.dart';

class SettingsPage extends StatelessWidget {

  const SettingsPage({ super.key });

  @override
  Widget build(BuildContext context) {
    return HBScaffold(
      appBar: HBAppBar(
        context: context,
        title: 'Einstellungen'
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: HBSpacing.lg,
          right: context.rightPadding + HBSpacing.lg,
          top: HBSpacing.lg,
          bottom: context.bottomPadding + HBSpacing.lg
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(
                  child: HBTextField(
                    icon: HBIcons.key,
                    hint: 'Datenbankadresse',
                    isEnabled: false
                  )
                ),
                const HBGap.md(),
                SizedBox(
                  width: HBUIConstants.textFieldButtonSize,
                  height: HBUIConstants.textFieldButtonSize,
                  child: RawMaterialButton(
                    onPressed: () {},
                    fillColor: HBColors.gray900,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(HBUIConstants.defaultBorderRadius)),
                    child: const HBIcon(
                      icon: HBIcons.pencil, 
                      color: HBColors.gray100,
                      size: HBUIConstants.textFieldButtonSize * 0.5
                    )
                  )
                )
              ]
            )
          ]
        )
      )
    );
  }
}
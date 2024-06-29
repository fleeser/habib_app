import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:habib_app/src/features/settings/presentation/app/settings_page_notifier.dart';
import 'package:habib_app/core/utils/core_utils.dart';
import 'package:habib_app/core/utils/enums/toast_type.dart';
import 'package:habib_app/core/common/widgets/hb_app_bar.dart';
import 'package:habib_app/core/common/widgets/hb_gap.dart';
import 'package:habib_app/core/common/widgets/hb_scaffold.dart';
import 'package:habib_app/core/common/widgets/hb_text_field.dart';
import 'package:habib_app/core/extensions/context_extension.dart';
import 'package:habib_app/core/res/hb_icons.dart';
import 'package:habib_app/core/res/theme/spacing/hb_spacing.dart';

class SettingsPage extends StatefulHookConsumerWidget {

  const SettingsPage({ super.key });

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {

  late TextEditingController _hostController;
  late TextEditingController _portController;
  late TextEditingController _userController;
  late TextEditingController _passwordController;
  late TextEditingController _dbController;

  void _onPageStateUpdate(SettingsPageState? _, SettingsPageState next) {
    if (next.status == SettingsPageStatus.success) {
      CoreUtils.showToast(
        context, 
        type: ToastType.success, 
        title: 'Speichern erfolgreich', 
        description: 'Die Einstellungen wurden erfolgreich übernommen.'
      );
    } else if (next.status == SettingsPageStatus.failure) {
      // TODO
    }
  }

  Future<void> _onSave() async {
    final String mySqlHost = _hostController.text.trim();
    final int mySqlPort = int.parse(_portController.text.trim());
    final String mySqlUser = _userController.text.trim();
    final String mySqlPassword = _passwordController.text.trim();
    final String mySqlDb = _dbController.text.trim();

    await ref.read(settingsPageNotifierProvider.notifier).saveSettings(
      mySqlHost: mySqlHost,
      mySqlPort: mySqlPort,
      mySqlUser: mySqlUser,
      mySqlPassword: mySqlPassword,
      mySqlDb: mySqlDb
    );
  }

  @override
  Widget build(BuildContext context) {

    final SettingsPageState pageState = ref.watch(settingsPageNotifierProvider);

    _hostController = useTextEditingController(text: pageState.settings.mySqlHost);
    _portController = useTextEditingController(text: pageState.settings.mySqlPort?.toString());
    _userController = useTextEditingController(text: pageState.settings.mySqlUser);
    _passwordController = useTextEditingController(text: pageState.settings.mySqlPassword);
    _dbController = useTextEditingController(text: pageState.settings.mySqlDb);

    ref.listen(
      settingsPageNotifierProvider,
      _onPageStateUpdate
    );

    return HBScaffold(
      appBar: HBAppBar(
        context: context,
        title: 'Einstellungen',
        actionButtons: [
          HBAppBarButton(
            onPressed: _onSave,
            icon: HBIcons.cloudArrowUp
          )
        ]
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: HBSpacing.lg,
          right: context.rightPadding + HBSpacing.lg,
          top: HBSpacing.lg
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: HBTextField(
                    title: 'Host',
                    controller: _hostController,
                    icon: HBIcons.home
                  )
                ),
                const HBGap.xl(),
                Expanded(
                  child: HBTextField(
                    title: 'Port',
                    controller: _portController,
                    icon: HBIcons.hashtag
                  )
                )
              ]
            ),
            const HBGap.xl(),
            Row(
              children: [
                Expanded(
                  child: HBTextField(
                    title: 'Benutzer',
                    controller: _userController,
                    icon: HBIcons.user
                  )
                ),
                const HBGap.xl(),
                Expanded(
                  child: HBTextField(
                    title: 'Passwort',
                    controller: _passwordController,
                    icon: HBIcons.key
                  )
                )
              ]
            ),
            const HBGap.xl(),
            Row(
              children: [
                Expanded(
                  child: HBTextField(
                    title: 'Datenbankname',
                    controller: _dbController,
                    icon: HBIcons.circleStack
                  )
                ),
                const HBGap.md(),
                const Spacer()
              ]
            )
          ]
        )
      )
    );
  }
}
import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:habib_app/core/common/widgets/hb_dialog.dart';
import 'package:habib_app/core/common/widgets/hb_gap.dart';
import 'package:habib_app/core/common/widgets/sc_text_field.dart';
import 'package:habib_app/core/res/hb_icons.dart';

class CreateCustomerPage extends StatefulHookWidget {
  
  const CreateCustomerPage({ super.key });

  @override
  State<CreateCustomerPage> createState() => _CreateCustomerPageState();
}

class _CreateCustomerPageState extends State<CreateCustomerPage> {

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _titleController;
  late TextEditingController _occupationController;
  late TextEditingController _phoneController;
  late TextEditingController _mobileController;
  
  @override
  Widget build(BuildContext context) {

    _firstNameController = useTextEditingController();
    _lastNameController = useTextEditingController();
    _titleController = useTextEditingController();
    _occupationController = useTextEditingController();
    _phoneController = useTextEditingController();
    _mobileController = useTextEditingController();

    return HBDialog<int>(
      title: 'Neuer Kunde',
      actionButton: HBDialogActionButton(
        onPressed: () {},
        title: 'Erstellen'
      ),
      children: [
        const HBDialogSection(title: 'Personendaten'),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: HBTextField(
                controller: _firstNameController,
                icon: HBIcons.user,
                hint: 'Vorname'
              )
            ),
            const HBGap.lg(),
            Expanded(
              child: HBTextField(
                controller: _lastNameController,
                icon: HBIcons.user,
                hint: 'Nachname'
              )
            )
          ]
        ),
        const HBGap.lg(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: HBTextField(
                controller: _titleController,
                icon: HBIcons.academicCap,
                hint: 'Titel'
              )
            ),
            const HBGap.lg(),
            const Spacer()
          ]
        ),
        const HBDialogSection(title: 'Beruf'),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: HBTextField(
                controller: _occupationController,
                icon: HBIcons.beaker,
                hint: 'Beruf'
              )
            ),
            const HBGap.lg(),
            const Spacer()
          ]
        ),
        const HBDialogSection(title: 'Kontakt'),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: HBTextField(
                controller: _phoneController,
                icon: HBIcons.phone,
                hint: 'Telefon'
              )
            ),
            const HBGap.lg(),
            Expanded(
              child: HBTextField(
                controller: _mobileController,
                icon: HBIcons.phone,
                hint: 'Mobil'
              )
            )
          ]
        ),
        const HBDialogSection(title: 'Anschrift')
      ]
    );
  }
}
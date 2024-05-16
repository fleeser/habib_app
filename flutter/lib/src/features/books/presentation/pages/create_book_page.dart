import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:habib_app/core/common/widgets/hb_dialog.dart';

class CreateBookPage extends StatefulHookWidget {
  
  const CreateBookPage({ super.key });

  @override
  State<CreateBookPage> createState() => _CreateBookPageState();
}

class _CreateBookPageState extends State<CreateBookPage> {
  
  @override
  Widget build(BuildContext context) {

    return HBDialog<int>(
      title: 'Neues Buch',
      actionButton: HBDialogActionButton(
        onPressed: () {},
        title: 'Erstellen'
      )
    );
  }
}
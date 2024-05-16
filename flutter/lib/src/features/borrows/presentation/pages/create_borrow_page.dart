import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:habib_app/core/common/widgets/hb_dialog.dart';

class CreateBorrowPage extends StatefulHookWidget {
  
  const CreateBorrowPage({ super.key });

  @override
  State<CreateBorrowPage> createState() => _CreateBorrowPageState();
}

class _CreateBorrowPageState extends State<CreateBorrowPage> {
  
  @override
  Widget build(BuildContext context) {

    return HBDialog<int>(
      title: 'Neue Ausleihe',
      actionButton: HBDialogActionButton(
        onPressed: () {},
        title: 'Erstellen'
      )
    );
  }
}
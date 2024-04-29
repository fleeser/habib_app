import 'package:flutter/material.dart';

import 'package:habib_app/core/common/widgets/hb_app_bar.dart';
import 'package:habib_app/core/common/widgets/hb_scaffold.dart';

class RemindersPage extends StatelessWidget {

  const RemindersPage({ super.key });

  @override
  Widget build(BuildContext context) {
    return HBScaffold(
      appBar: HBAppBar(
        context: context, 
        title: 'Erinnerungen'
      )
    );
  }
}
import 'package:flutter/material.dart';

import 'package:habib_app/core/common/widgets/hb_app_bar.dart';
import 'package:habib_app/core/common/widgets/hb_scaffold.dart';

class BorrowDetailsPageParams {

  final int borrowId;

  const BorrowDetailsPageParams({
    required this.borrowId
  });
}

class BorrowDetailsPage extends StatelessWidget {

  final BorrowDetailsPageParams params;
  
  const BorrowDetailsPage({ 
    super.key,
    required this.params
  });

  @override
  Widget build(BuildContext context) {
    return HBScaffold(
      appBar: HBAppBar(
        context: context,
        title: 'Details',
        backButton: const HBAppBarBackButton()
      )
    );
  }
}
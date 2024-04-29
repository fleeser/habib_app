import 'package:flutter/material.dart';

import 'package:habib_app/core/common/widgets/hb_app_bar.dart';
import 'package:habib_app/core/common/widgets/hb_scaffold.dart';

class BookDetailsPageParams {

  final int bookId;

  const BookDetailsPageParams({
    required this.bookId
  });
}

class BookDetailsPage extends StatelessWidget {

  final BookDetailsPageParams params;
  
  const BookDetailsPage({ 
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
import 'package:flutter/material.dart';
import 'package:habib_app/core/common/widgets/hb_app_bar.dart';
import 'package:habib_app/core/common/widgets/hb_scaffold.dart';

class CustomerDetailsPageParams {

  final int customerId;

  const CustomerDetailsPageParams({
    required this.customerId
  });
}

class CustomerDetailsPage extends StatelessWidget {

  final CustomerDetailsPageParams params;
  
  const CustomerDetailsPage({ 
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
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:habib_app/core/res/theme/spacing/hb_spacing.dart';
import 'package:habib_app/core/utils/enums/borrow_status.dart';
import 'package:habib_app/core/common/widgets/hb_chip.dart';
import 'package:habib_app/core/common/widgets/hb_selection_dialog.dart';

Future<BorrowStatus?> showBorrowStatusSelectionDialog({
  required BuildContext context
}) async {
  return await showHBSelectionDialog<BorrowStatus>(
    context: context,
    title: 'Status wählen',
    content: const BorrowStatusSelectionDialog()
  );
}

class BorrowStatusSelectionDialog extends StatelessWidget {

  const BorrowStatusSelectionDialog({ super.key });

  void _onStatusPressed(BuildContext context, BorrowStatus status) async {
    context.pop<BorrowStatus>(status);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: HBSpacing.lg),
      child: HBChips(
        chips: List.generate(BorrowStatus.values.length, (int index) {
          final BorrowStatus status = BorrowStatus.values[index];
          return HBChip(
            onPressed: () => _onStatusPressed(context, status),
            text: status.title, 
            color: status.color
          );
        })
      )
    );
  }
}
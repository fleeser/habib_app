import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:habib_app/core/common/widgets/hb_table.dart';
import 'package:habib_app/core/extensions/exception_extension.dart';
import 'package:habib_app/core/utils/enums/toast_type.dart';
import 'package:habib_app/core/common/widgets/hb_app_bar.dart';
import 'package:habib_app/core/common/widgets/hb_button.dart';
import 'package:habib_app/core/common/widgets/hb_gap.dart';
import 'package:habib_app/core/common/widgets/hb_scaffold.dart';
import 'package:habib_app/core/common/widgets/sc_text_field.dart';
import 'package:habib_app/core/extensions/context_extension.dart';
import 'package:habib_app/core/res/hb_icons.dart';
import 'package:habib_app/core/res/theme/spacing/hb_spacing.dart';
import 'package:habib_app/core/services/routes.dart';
import 'package:habib_app/core/utils/constants/hb_ui_constants.dart';
import 'package:habib_app/core/utils/core_utils.dart';
import 'package:habib_app/src/features/borrows/domain/entities/borrow_entity.dart';
import 'package:habib_app/src/features/borrows/presentation/app/borrows_page_notifier.dart';

class BorrowsPage extends ConsumerStatefulWidget {

  const BorrowsPage({ super.key });

  @override
  ConsumerState<BorrowsPage> createState() => _BorrowsPageState();
}

class _BorrowsPageState extends ConsumerState<BorrowsPage> {

  final ScrollController _scrollController = ScrollController();

  void _onPageStateUpdate(BorrowsPageState? _, BorrowsPageState next) {
    if (next.exception != null) {
      CoreUtils.showToast(
        context, 
        type: ToastType.error, 
        title: next.exception!.title(context), 
        description: next.exception!.description(context)
      );
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final double maxScroll = _scrollController.position.maxScrollExtent;
    final double currentScroll = _scrollController.offset;
    return currentScroll >= maxScroll * 0.9;
  }

  void _onScroll() {
    if (_isBottom) {
      ref.read(borrowsPageNotifierProvider.notifier).fetchNextPage();
    }
  }

  HBTableStatus get _tableStatus {
    final BorrowsPageState pageState = ref.read(borrowsPageNotifierProvider);
    if (pageState.status == BorrowsPageStatus.success && pageState.borrows.isNotEmpty) return HBTableStatus.data;
    if (pageState.status == BorrowsPageStatus.failure || (pageState.status == BorrowsPageStatus.success && pageState.borrows.isEmpty)) return HBTableStatus.text;
    return HBTableStatus.loading;
  }

  String? get _tableText {
    final BorrowsPageState pageState = ref.read(borrowsPageNotifierProvider);
    if (pageState.status == BorrowsPageStatus.success && pageState.borrows.isEmpty) return 'Keine Ausleihen gefunden.';
    if (pageState.status == BorrowsPageStatus.failure) return 'Ein Fehler ist aufgetreten.';
    return null;
  }

  Future<void> _onBorrowPressed(int borrowId) async {
    await BorrowDetailsRoute(borrowId: borrowId).push(context);
  }

  Future<void> _onCreateBorrow() async {
    await const CreateBorrowRoute().push(context);
  }

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    CoreUtils.postFrameCall(() {
      ref.read(borrowsPageNotifierProvider.notifier).fetchNextPage();
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final BorrowsPageState pageState = ref.watch(borrowsPageNotifierProvider);

    ref.listen<BorrowsPageState>(
      borrowsPageNotifierProvider,
      _onPageStateUpdate
    );

    return HBScaffold(
      appBar: HBAppBar(
        context: context, 
        title: 'Ausleihen'
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: HBSpacing.lg,
              right: context.rightPadding + HBSpacing.lg,
              top: HBSpacing.lg
            ),
            child: Row(
              children: [
                const HBTextField(
                  icon: HBIcons.magnifyingGlass,
                  hint: 'Buchtitel oder Kundenname',
                  maxWidth: 500.0
                ),
                const HBGap.lg(),
                const Spacer(),
                HBButton.shrinkFill(
                  onPressed: _onCreateBorrow,
                  icon: HBIcons.plus,
                  title: 'Neue Ausleihe'
                )
              ]
            )
          ),
          Expanded(
            child: HBTable(
              onPressed: (int index) => _onBorrowPressed(pageState.borrows[index].id),
              status: _tableStatus,
              padding: EdgeInsets.only(
                left: HBSpacing.lg,
                right: context.rightPadding + HBSpacing.lg,
                bottom: context.bottomPadding + HBSpacing.lg,
                top: HBSpacing.xxl
              ),
              controller: _scrollController,
              tableWidth: context.width - HBUIConstants.navigationRailWidth - context.rightPadding - 4.0 * HBSpacing.lg,
              columnLength: 2,
              fractions: const [ 0.1, 0.45, 0.45 ],
              titles: const [ 'ID', 'Kundenname', 'Buchtitel' ],
              items: List.generate(pageState.borrows.length, (int index) {
                final BorrowEntity borrow = pageState.borrows[index];
                return [
                  borrow.id.toString(),
                  '${borrow.customer?.firstName ?? 'Unbekannt'} ${borrow.customer?.lastName ?? 'Unbekannt'}',
                  borrow.book?.title ?? 'Unbekannt'
                ];
              }),
              text: _tableText
            )
          )
        ]
      )
    );
  }
}
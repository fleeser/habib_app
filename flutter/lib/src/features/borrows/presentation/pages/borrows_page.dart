import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:habib_app/core/extensions/datetime_extension.dart';
import 'package:habib_app/core/extensions/object_extension.dart';
import 'package:habib_app/core/common/widgets/hb_chip.dart';
import 'package:habib_app/core/common/widgets/hb_table.dart';
import 'package:habib_app/core/utils/enums/toast_type.dart';
import 'package:habib_app/core/common/widgets/hb_app_bar.dart';
import 'package:habib_app/core/common/widgets/hb_button.dart';
import 'package:habib_app/core/common/widgets/hb_gap.dart';
import 'package:habib_app/core/common/widgets/hb_scaffold.dart';
import 'package:habib_app/core/common/widgets/hb_text_field.dart';
import 'package:habib_app/core/extensions/context_extension.dart';
import 'package:habib_app/core/res/hb_icons.dart';
import 'package:habib_app/core/res/theme/spacing/hb_spacing.dart';
import 'package:habib_app/core/services/routes.dart';
import 'package:habib_app/core/utils/constants/hb_ui_constants.dart';
import 'package:habib_app/core/utils/core_utils.dart';
import 'package:habib_app/src/features/borrows/domain/entities/borrow_entity.dart';
import 'package:habib_app/src/features/borrows/presentation/app/borrows_page_notifier.dart';

class BorrowsPage extends StatefulHookConsumerWidget {

  const BorrowsPage({ super.key });

  @override
  ConsumerState<BorrowsPage> createState() => _BorrowsPageState();
}

class _BorrowsPageState extends ConsumerState<BorrowsPage> {

  final ScrollController _scrollController = ScrollController();

  late TextEditingController _searchController;

  void _onPageStateUpdate(BorrowsPageState? _, BorrowsPageState next) {
    if (next.hasError) {
      CoreUtils.showToast(
        context, 
        type: ToastType.error, 
        title: next.error!.errorTitle, 
        description: next.error!.errorDescription, 
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
      ref.read(borrowsPageNotifierProvider.notifier).fetchNextPage(_searchText);
    }
  }

  HBTableStatus get _tableStatus {
    final BorrowsPageState pageState = ref.read(borrowsPageNotifierProvider);
    if (pageState.hasBorrows) return HBTableStatus.data;
    if (pageState.hasError || !pageState.hasBorrows) return HBTableStatus.text;
    return HBTableStatus.loading;
  }

  String? get _tableText {
    final BorrowsPageState pageState = ref.read(borrowsPageNotifierProvider);
    if (!pageState.isLoading && !pageState.hasError && !pageState.hasBorrows) return 'Keine Ausleihen gefunden.';
    if (pageState.hasError) return 'Ein Fehler ist aufgetreten.';
    return null;
  }

  String get _searchText {
    return _searchController.text.trim();
  }

  Future<void> _onBorrowPressed(int borrowId) async {
    await BorrowDetailsRoute(borrowId: borrowId).push(context);
  }

  Future<void> _onCreateBorrow() async {
    await const CreateBorrowRoute().push(context);
  }

  Future<void> _onSearchChanged(String _) async {
    await ref.read(borrowsPageNotifierProvider.notifier).refresh(_searchText);
  }

  Future<void> _onRefresh() async {
    await ref.read(borrowsPageNotifierProvider.notifier).refresh(_searchText);
  }

  Future<void> _onCustomerPressed(int customerId) async {
    final bool? customerDeleted = await CustomerDetailsRoute(customerId: customerId).push(context);
    if (customerDeleted ?? false) ref.read(borrowsPageNotifierProvider.notifier).refresh(_searchText);
  }

  Future<void> _onBookPressed(int bookId) async {
    await BookDetailsRoute(bookId: bookId).push(context);
  }

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    CoreUtils.postFrameCall(() {
      ref.read(borrowsPageNotifierProvider.notifier).fetchNextPage(_searchText);
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

    _searchController = useTextEditingController();

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
                HBTextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
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
                ),
                const HBGap.md(),
                HBButton.shrinkFill(
                  onPressed: _onRefresh,
                  icon: HBIcons.arrowPath
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
              columnLength: 4,
              fractions: const [ 0.35, 0.35, 0.15, 0.15 ],
              titles: const [ 'Kundenname', 'Buchtitel (Auflage)', 'Rückgabedatum', 'Status' ],
              items: List.generate(pageState.borrows.length, (int index) {
                final BorrowEntity borrow = pageState.borrows[index];
                return [
                  HBTableText(
                    onPressed: () => _onCustomerPressed(borrow.customer.id),
                    text: '${ borrow.customer.title != null ? '${ borrow.customer.title } ' : '' }${ borrow.customer.firstName } ${ borrow.customer.lastName }'
                  ),
                  HBTableText(
                    onPressed: () => _onBookPressed(borrow.book.id),
                    text: '${ borrow.book.title }${ borrow.book.edition != null ? ' (${ borrow.book.edition }. Auflage)' : '' }'
                  ),
                  HBTableText(text: borrow.endDate.toHumanReadableDate()),
                  HBTableChip(
                    chip: HBChip(
                      text: borrow.status.title, 
                      color: borrow.status.color
                    )
                  )
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
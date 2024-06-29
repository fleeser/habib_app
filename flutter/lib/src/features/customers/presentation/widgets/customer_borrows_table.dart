import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:habib_app/src/features/borrows/presentation/pages/create_borrow_page.dart';
import 'package:habib_app/src/features/customers/presentation/app/customer_details_page_notifier.dart';
import 'package:habib_app/core/extensions/object_extension.dart';
import 'package:habib_app/core/common/widgets/hb_button.dart';
import 'package:habib_app/core/common/widgets/hb_chip.dart';
import 'package:habib_app/core/common/widgets/hb_gap.dart';
import 'package:habib_app/core/common/widgets/hb_table.dart';
import 'package:habib_app/core/common/widgets/hb_text_field.dart';
import 'package:habib_app/core/extensions/context_extension.dart';
import 'package:habib_app/core/extensions/datetime_extension.dart';
import 'package:habib_app/core/res/hb_icons.dart';
import 'package:habib_app/core/res/theme/colors/hb_colors.dart';
import 'package:habib_app/core/res/theme/spacing/hb_spacing.dart';
import 'package:habib_app/core/res/theme/typography/hb_typography.dart';
import 'package:habib_app/core/services/routes.dart';
import 'package:habib_app/core/utils/constants/hb_ui_constants.dart';
import 'package:habib_app/core/utils/core_utils.dart';
import 'package:habib_app/core/utils/enums/toast_type.dart';
import 'package:habib_app/src/features/customers/domain/entities/customer_borrow_entity.dart';
import 'package:habib_app/src/features/customers/presentation/app/customer_borrows_notifier.dart';

class CustomerBorrowsTable extends StatefulHookConsumerWidget {

  final int customerId;

  const CustomerBorrowsTable({ 
    super.key,
    required this.customerId
  });

  @override
  ConsumerState<CustomerBorrowsTable> createState() => _CustomerBorrowsTableState();
}

class _CustomerBorrowsTableState extends ConsumerState<CustomerBorrowsTable> {

  final ScrollController _scrollController = ScrollController();

  late TextEditingController _searchController;

  void _onBorrowsStateUpdate(CustomerBorrowsState? _, CustomerBorrowsState next) {
    if (next.hasError) {
      CoreUtils.showToast(
        context, 
        type: ToastType.error, 
        title: next.error!.errorTitle, 
        description: next.error!.errorDescription, 
      );
    }
  }

  Future<void> _onBorrowPressed(int borrowId) async {
    await BorrowDetailsRoute(borrowId: borrowId).push(context);
  }

  Future<void> _onSearchChanged(String _) async {
    await ref.read(customerBorrowsNotifierProvider(widget.customerId).notifier).refresh(_searchText);
  }

  Future<void> _onRefreshBorrows() async {
    await ref.read(customerBorrowsNotifierProvider(widget.customerId).notifier).refresh(_searchText);
  }

  Future<void> _onBookPressed(int bookId) async {
    await BookDetailsRoute(bookId: bookId).push(context);
  }

  Future<void> _onNewBorrow() async {
    final CustomerDetailsPageState pageState = ref.read(customerDetailsPageNotifierProvider(widget.customerId));
    if (!pageState.hasCustomer) return;
    final CreateBorrowCustomer customer = CreateBorrowCustomer(
      id: pageState.customer!.id,
      title: pageState.customer!.title,
      firstName: pageState.customer!.firstName,
      lastName: pageState.customer!.lastName
    );
    final CreateBorrowPageParams params = CreateBorrowPageParams(customer: customer);
    await CreateBorrowRoute($extra: params).push(context);
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final double maxScroll = _scrollController.position.maxScrollExtent;
    final double currentScroll = _scrollController.offset;
    return currentScroll >= maxScroll * 0.9;
  }

  void _onScroll() {
    if (_isBottom) {
      ref.read(customerBorrowsNotifierProvider(widget.customerId).notifier).fetchNextPage(_searchText);
    }
  }

  String get _searchText {
    return _searchController.text.trim();
  }

  HBTableStatus get _tableStatus {
    final CustomerBorrowsState pageState = ref.read(customerBorrowsNotifierProvider(widget.customerId));
    if (pageState.hasCustomerBorrows) return HBTableStatus.data;
    if (pageState.hasError || !pageState.hasCustomerBorrows) return HBTableStatus.text;
    return HBTableStatus.loading;
  }

  String? get _tableText {
    final CustomerBorrowsState pageState = ref.read(customerBorrowsNotifierProvider(widget.customerId));
    if (!pageState.isLoading && !pageState.hasError && !pageState.hasCustomerBorrows) return 'Keine Ausleihen gefunden.';
    if (pageState.hasError) return 'Ein Fehler ist aufgetreten.';
    return null;
  }

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    CoreUtils.postFrameCall(() {
      ref.read(customerBorrowsNotifierProvider(widget.customerId).notifier).fetchNextPage(_searchText);
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

    final CustomerBorrowsState borrowsState = ref.watch(customerBorrowsNotifierProvider(widget.customerId));

    _searchController = useTextEditingController();

    ref.listen<CustomerBorrowsState>(
      customerBorrowsNotifierProvider(widget.customerId),
      _onBorrowsStateUpdate
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: HBSpacing.lg,
            right: context.rightPadding + HBSpacing.lg,
            top: HBSpacing.lg
          ),
          child: Text(
            'Ausleihen',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: HBTypography.base.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 20.0,
              color: HBColors.gray900
            )
          )
        ),
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
                hint: 'Buchtitel',
                maxWidth: 500.0
              ),
              const HBGap.lg(),
              const Spacer(),
              HBButton.shrinkFill(
                onPressed: _onNewBorrow,
                icon: HBIcons.plus,
                title: 'Neue Ausleihe'
              ),
              const HBGap.md(),
              HBButton.shrinkFill(
                onPressed: _onRefreshBorrows,
                icon: HBIcons.arrowPath
              )
            ]
          )
        ),
        Expanded(
          child: HBTable(
            onPressed: (int index) => _onBorrowPressed(borrowsState.customerBorrows[index].id),
            status: _tableStatus,
            padding: EdgeInsets.only(
              left: HBSpacing.lg,
              right: context.rightPadding + HBSpacing.lg,
              bottom: context.bottomPadding + HBSpacing.lg,
              top: HBSpacing.xxl
            ),
            controller: _scrollController,
            tableWidth: context.width - HBUIConstants.navigationRailWidth - context.rightPadding - 4.0 * HBSpacing.lg,
            columnLength: 3,
            fractions: const [ 0.7, 0.15, 0.15 ],
            titles: const [ 'Buchtitel (Auflage)', 'Rückgabedatum', 'Status' ],
            items: List.generate(borrowsState.customerBorrows.length, (int index) {
              final CustomerBorrowEntity borrow = borrowsState.customerBorrows[index];
              return [
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
    );
  }
}
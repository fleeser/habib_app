import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:habib_app/src/features/books/presentation/app/book_details_page_notifier.dart';
import 'package:habib_app/src/features/borrows/presentation/pages/create_borrow_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
import 'package:habib_app/src/features/books/domain/entities/book_borrow_entity.dart';
import 'package:habib_app/src/features/books/presentation/app/book_borrows_notifier.dart';

class BookBorrowsTable extends StatefulHookConsumerWidget {

  final int bookId;

  const BookBorrowsTable({ 
    super.key,
    required this.bookId
  });

  @override
  ConsumerState<BookBorrowsTable> createState() => _BookBorrowsTableState();
}

class _BookBorrowsTableState extends ConsumerState<BookBorrowsTable> {

  final ScrollController _scrollController = ScrollController();

  late TextEditingController _searchController;

  void _onBorrowsStateUpdate(BookBorrowsState? _, BookBorrowsState next) {
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
    await ref.read(bookBorrowsNotifierProvider(widget.bookId).notifier).refresh(_searchText);
  }

  Future<void> _onRefreshBorrows() async {
    await ref.read(bookBorrowsNotifierProvider(widget.bookId).notifier).refresh(_searchText);
  }

  Future<void> _onCustomerPressed(int customerId) async {
    await CustomerDetailsRoute(customerId: customerId).push(context);
  }

  Future<void> _onNewBorrow() async {
    final BookDetailsPageState pageState = ref.read(bookDetailsPageNotifierProvider(widget.bookId));
    if (!pageState.hasBook) return;
    final CreateBorrowBook book = CreateBorrowBook(
      id: pageState.book!.id,
      title: pageState.book!.title,
      edition: pageState.book!.edition
    );
    final CreateBorrowPageParams params = CreateBorrowPageParams(book: book);
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
      ref.read(bookBorrowsNotifierProvider(widget.bookId).notifier).fetchNextPage(_searchText);
    }
  }

  String get _searchText {
    return _searchController.text.trim();
  }

  HBTableStatus get _tableStatus {
    final BookBorrowsState pageState = ref.read(bookBorrowsNotifierProvider(widget.bookId));
    if (pageState.hasBooksBorrows) return HBTableStatus.data;
    if (pageState.hasError || !pageState.hasBooksBorrows) return HBTableStatus.text;
    return HBTableStatus.loading;
  }

  String? get _tableText {
    final BookBorrowsState pageState = ref.read(bookBorrowsNotifierProvider(widget.bookId));
    if (!pageState.isLoading && !pageState.hasError && !pageState.hasBooksBorrows) return 'Keine Ausleihen gefunden.';
    if (pageState.hasError) return 'Ein Fehler ist aufgetreten.';
    return null;
  }

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    CoreUtils.postFrameCall(() {
      ref.read(bookBorrowsNotifierProvider(widget.bookId).notifier).fetchNextPage(_searchText);
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

    final BookBorrowsState borrowsState = ref.watch(bookBorrowsNotifierProvider(widget.bookId));

    _searchController = useTextEditingController();

    ref.listen<BookBorrowsState>(
      bookBorrowsNotifierProvider(widget.bookId),
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
                hint: 'Kundenname',
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
            onPressed: (int index) => _onBorrowPressed(borrowsState.bookBorrows[index].id),
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
            titles: const [ 'Kundenname', 'Rückgabedatum', 'Status' ],
            items: List.generate(borrowsState.bookBorrows.length, (int index) {
              final BookBorrowEntity borrow = borrowsState.bookBorrows[index];
              return [
                HBTableText(
                  onPressed: () => _onCustomerPressed(borrow.customer.id),
                  text: '${ borrow.customer.title != null ? '${ borrow.customer.title } ' : '' }${ borrow.customer.firstName } ${ borrow.customer.lastName }'
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
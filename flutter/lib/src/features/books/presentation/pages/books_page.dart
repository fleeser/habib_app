import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:habib_app/src/features/books/domain/entities/book_entity.dart';
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
import 'package:habib_app/src/features/books/presentation/app/books_page_notifier.dart';

class BooksPage extends ConsumerStatefulWidget {

  const BooksPage({ super.key });

  @override
  ConsumerState<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends ConsumerState<BooksPage> {

  final ScrollController _scrollController = ScrollController();

  void _onPageStateUpdate(BooksPageState? _, BooksPageState next) {
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
      ref.read(booksPageNotifierProvider.notifier).fetchNextPage();
    }
  }

  HBTableStatus get _tableStatus {
    final BooksPageState pageState = ref.read(booksPageNotifierProvider);
    if (pageState.status == BooksPageStatus.success && pageState.books.isNotEmpty) return HBTableStatus.data;
    if (pageState.status == BooksPageStatus.failure || (pageState.status == BooksPageStatus.success && pageState.books.isEmpty)) return HBTableStatus.text;
    return HBTableStatus.loading;
  }

  String? get _tableText {
    final BooksPageState pageState = ref.read(booksPageNotifierProvider);
    if (pageState.status == BooksPageStatus.success && pageState.books.isEmpty) return 'Keine Bücher gefunden.';
    if (pageState.status == BooksPageStatus.failure) return 'Ein Fehler ist aufgetreten.';
    return null;
  }

  Future<void> _onBookPressed(int bookId) async {
    await BookDetailsRoute(bookId: bookId).push(context);
  }

  Future<void> _onCreateBook() async {
    await const CreateBookRoute().push(context);
  }

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    CoreUtils.postFrameCall(() {
      ref.read(booksPageNotifierProvider.notifier).fetchNextPage();
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

    final BooksPageState pageState = ref.watch(booksPageNotifierProvider);

    ref.listen<BooksPageState>(
      booksPageNotifierProvider,
      _onPageStateUpdate
    );

    return HBScaffold(
      appBar: HBAppBar(
        context: context, 
        title: 'Bücher'
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
                  hint: 'Buchtitel oder ISBN',
                  maxWidth: 500.0
                ),
                const HBGap.lg(),
                const Spacer(),
                HBButton.shrinkFill(
                  onPressed: _onCreateBook,
                  icon: HBIcons.plus,
                  title: 'Neues Buch'
                )
              ]
            )
          ),
          Expanded(
            child: HBTable(
              onPressed: (int index) => _onBookPressed(pageState.books[index].id),
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
              fractions: const [ 0.1, 0.9 ],
              titles: const [ 'ID', 'Titel' ],
              items: List.generate(pageState.books.length, (int index) {
                final BookEntity book = pageState.books[index];
                return [
                  book.id.toString(),
                  book.title
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
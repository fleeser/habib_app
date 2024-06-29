import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:habib_app/core/extensions/object_extension.dart';
import 'package:habib_app/core/common/widgets/hb_chip.dart';
import 'package:habib_app/src/features/books/domain/entities/book_author_entity.dart';
import 'package:habib_app/src/features/books/domain/entities/book_entity.dart';
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
import 'package:habib_app/src/features/books/presentation/app/books_page_notifier.dart';

class BooksPage extends StatefulHookConsumerWidget {

  const BooksPage({ super.key });

  @override
  ConsumerState<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends ConsumerState<BooksPage> {

  final ScrollController _scrollController = ScrollController();

  late TextEditingController _searchController;

  void _onPageStateUpdate(BooksPageState? _, BooksPageState next) {
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
      ref.read(booksPageNotifierProvider.notifier).fetchNextPage(_searchText);
    }
  }

  HBTableStatus get _tableStatus {
    final BooksPageState pageState = ref.read(booksPageNotifierProvider);
    if (pageState.hasBooks) return HBTableStatus.data;
    if (pageState.hasError || !pageState.hasBooks) return HBTableStatus.text;
    return HBTableStatus.loading;
  }

  String? get _tableText {
    final BooksPageState pageState = ref.read(booksPageNotifierProvider);
    if (!pageState.isLoading && !pageState.hasError && !pageState.hasBooks) return 'Keine Bücher gefunden.';
    if (pageState.hasError) return 'Ein Fehler ist aufgetreten.';
    return null;
  }

  String get _searchText {
    return _searchController.text.trim();
  }

  Future<void> _onBookPressed(int bookId) async {
    await BookDetailsRoute(bookId: bookId).push(context);
  }

  Future<void> _onCreateBook() async {
    await const CreateBookRoute().push(context);
  }

  Future<void> _onSearchChanged(String _) async {
    await ref.read(booksPageNotifierProvider.notifier).refresh(_searchText);
  }

  Future<void> _onRefresh() async {
    await ref.read(booksPageNotifierProvider.notifier).refresh(_searchText);
  }

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    CoreUtils.postFrameCall(() {
      ref.read(booksPageNotifierProvider.notifier).fetchNextPage(_searchText);
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

    _searchController = useTextEditingController();

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
                HBTextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
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
              columnLength: 5,
              fractions: const [ 0.3, 0.2, 0.2, 0.2, 0.1 ],
              titles: const [ 'Titel (Auflage)', 'Autor', 'ISBN 10', 'ISBN 13', 'Status' ],
              items: List.generate(pageState.books.length, (int index) {
                final BookEntity book = pageState.books[index];
                return [
                  HBTableText(text: '${ book.title }${ book.edition != null ? ' (${ book.edition }. Auflage)' : '' }'),
                  HBTableText(text: (book.authors ?? []).map((BookAuthorEntity author) => '${ author.title != null ? '${ author.title } ' : '' }${ author.firstName } ${ author.lastName }').join(', ')),
                  HBTableText(text: book.isbn10 ?? ''),
                  HBTableText(text: book.isbn13 ?? ''),
                  HBTableChip(
                    chip: HBChip(
                      text: book.status.title, 
                      color: book.status.color
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
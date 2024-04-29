import 'package:flutter/material.dart';

import 'package:flutter_conditional/flutter_conditional.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:habib_app/core/extensions/exception_extension.dart';
import 'package:habib_app/core/utils/enums/toast_type.dart';
import 'package:habib_app/core/common/widgets/hb_app_bar.dart';
import 'package:habib_app/core/common/widgets/hb_button.dart';
import 'package:habib_app/core/common/widgets/hb_gap.dart';
import 'package:habib_app/core/common/widgets/hb_scaffold.dart';
import 'package:habib_app/core/common/widgets/sc_text_field.dart';
import 'package:habib_app/core/extensions/context_extension.dart';
import 'package:habib_app/core/res/hb_icons.dart';
import 'package:habib_app/core/res/theme/colors/hb_colors.dart';
import 'package:habib_app/core/res/theme/spacing/hb_spacing.dart';
import 'package:habib_app/core/res/theme/typography/hb_typography.dart';
import 'package:habib_app/core/services/routes.dart';
import 'package:habib_app/core/utils/constants/hb_ui_constants.dart';
import 'package:habib_app/core/utils/core_utils.dart';
import 'package:habib_app/src/features/books/domain/entities/book_entity.dart';
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

  Future<void> _onBookPressed(int bookId) async {
    await BookDetailsRoute(bookId: bookId).push(context);
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

    final double tableWidth = context.width - HBUIConstants.navigationRailWidth - context.rightPadding - 4.0 * HBSpacing.lg;

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
            child: const Row(
              children: [
                HBTextField(
                  icon: HBIcons.magnifyingGlass,
                  hint: 'Buchtitel oder ISBN',
                  maxWidth: 500.0
                ),
                HBGap.lg(),
                Spacer(),
                HBButton.shrinkFill(
                  icon: HBIcons.plus,
                  title: 'Neues Buch'
                )
              ]
            )
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 2.0 * HBSpacing.lg,
              right: context.rightPadding + 2.0 * HBSpacing.lg,
              top: HBSpacing.xxl,
              bottom: HBSpacing.lg
            ),
            child: Row(
              children: [
                SizedBox(
                  width: tableWidth * 0.1,
                  child: Text(
                    'ID',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: HBTypography.base.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: HBColors.gray900
                    )
                  )
                ),
                SizedBox(
                  width: tableWidth * 0.9,
                  child: Text(
                    'Titel',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: HBTypography.base.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: HBColors.gray900
                    )
                  )
                )
              ]
            )
          ),
          Expanded(
            child: Conditional.multiCase(
              cases: <Case>[
                Case(
                  condition: pageState.status == BooksPageStatus.success && pageState.books.isNotEmpty,
                  widget: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.only(
                      left: HBSpacing.lg,
                      right: context.rightPadding + HBSpacing.lg,
                      bottom: context.bottomPadding + HBSpacing.lg
                    ),
                    itemCount: pageState.books.length,
                    itemBuilder: (BuildContext context, int index) {

                      final BookEntity book = pageState.books[index];

                      return SizedBox(
                        height: 50.0,
                        child: RawMaterialButton(
                          onPressed: () => _onBookPressed(book.id),
                          padding: const EdgeInsets.symmetric(horizontal: HBSpacing.lg),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(HBUIConstants.defaultBorderRadius)),
                          child: Row(
                            children: [
                              SizedBox(
                                width: tableWidth * 0.1,
                                child: Text(
                                  book.id.toString(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: HBTypography.base.copyWith(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                    color: HBColors.gray900
                                  )
                                )
                              ),
                              SizedBox(
                                width: tableWidth * 0.9,
                                child: Text(
                                  book.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: HBTypography.base.copyWith(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                    color: HBColors.gray900
                                  )
                                )
                              )
                            ]
                          )
                        )
                      );
                    }
                  )
                ),
                Case(
                  condition: pageState.status == BooksPageStatus.success && pageState.books.isEmpty,
                  widget: Center(
                    child: Text(
                      'Keine Bücher gefunden.',
                      textAlign: TextAlign.center,
                      style: HBTypography.base.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: HBColors.gray900
                      )
                    )
                  )
                ),
                Case(
                  condition: pageState.status == BooksPageStatus.failure,
                  widget: Center(
                    child: Text(
                      'Ein Fehler ist aufgetreten.',
                      textAlign: TextAlign.center,
                      style: HBTypography.base.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: HBColors.gray900
                      )
                    )
                  )
                )
              ]
            )
          )
        ]
      )
    );
  }
}
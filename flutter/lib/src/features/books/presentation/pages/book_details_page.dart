import 'package:flutter/material.dart';
import 'package:flutter_conditional/flutter_conditional.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import 'package:habib_app/core/common/widgets/hb_checkbox.dart';
import 'package:habib_app/core/common/widgets/hb_chip.dart';
import 'package:habib_app/core/common/widgets/hb_date_button.dart';
import 'package:habib_app/core/common/widgets/hb_light_button.dart';
import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/core/utils/validator.dart';
import 'package:habib_app/src/features/authors/presentation/widgets/authors_selection_dialog.dart';
import 'package:habib_app/src/features/books/domain/entities/book_details_author_entity.dart';
import 'package:habib_app/src/features/books/domain/entities/book_details_category_entity.dart';
import 'package:habib_app/src/features/books/domain/entities/book_details_entity.dart';
import 'package:habib_app/src/features/books/domain/entities/book_details_publisher_entity.dart';
import 'package:habib_app/src/features/books/domain/usecases/book_update_book_usecase.dart';
import 'package:habib_app/src/features/books/presentation/pages/create_book_page.dart';
import 'package:habib_app/src/features/categories/presentation/widgets/categories_selection_dialog.dart';
import 'package:habib_app/src/features/publishers/presentation/widgets/publishers_selection_dialog.dart';
import 'package:habib_app/src/features/books/domain/usecases/book_delete_book_usecase.dart';
import 'package:habib_app/src/features/books/presentation/app/book_details_page_notifier.dart';
import 'package:habib_app/src/features/books/presentation/widgets/book_borrows_table.dart';
import 'package:habib_app/core/res/theme/colors/hb_colors.dart';
import 'package:habib_app/core/res/theme/typography/hb_typography.dart';
import 'package:habib_app/core/common/widgets/hb_gap.dart';
import 'package:habib_app/core/common/widgets/hb_text_field.dart';
import 'package:habib_app/core/extensions/context_extension.dart';
import 'package:habib_app/core/res/theme/spacing/hb_spacing.dart';
import 'package:habib_app/core/common/models/error_details.dart';
import 'package:habib_app/core/common/widgets/hb_message_box.dart';
import 'package:habib_app/core/utils/result.dart';
import 'package:habib_app/core/extensions/object_extension.dart';
import 'package:habib_app/core/utils/enums/toast_type.dart';
import 'package:habib_app/core/common/widgets/hb_app_bar.dart';
import 'package:habib_app/core/common/widgets/hb_scaffold.dart';
import 'package:habib_app/core/res/hb_icons.dart';
import 'package:habib_app/core/utils/core_utils.dart';

class BookDetailsPageParams {

  final int bookId;

  const BookDetailsPageParams({
    required this.bookId
  });
}

class BookDetailsPage extends StatefulHookConsumerWidget {

  final BookDetailsPageParams params;
  
  const BookDetailsPage({ 
    super.key,
    required this.params
  });

  @override
  ConsumerState<BookDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends ConsumerState<BookDetailsPage> {

  late TextEditingController _titleController;
  late TextEditingController _isbn10Controller;
  late TextEditingController _isbn13Controller;
  late TextEditingController _editionController;
  late ValueNotifier<List<BookDetailsAuthorEntity>> _authorsNotifier;
  late ValueNotifier<List<BookDetailsCategoryEntity>> _categoriesNotifier;
  late ValueNotifier<DateTime?> _publishDateNotifier;
  late ValueNotifier<List<BookDetailsPublisherEntity>> _publishersNotifier;
  late ValueNotifier<DateTime> _receivedAtNotifier;
  late ValueNotifier<bool> _boughtNotifier;

  void _onDetailsStateUpdate(BookDetailsPageState? _, BookDetailsPageState next) {
    if (next.hasError) {
      CoreUtils.showToast(
        context, 
        type: ToastType.error, 
        title: next.error!.errorTitle, 
        description: next.error!.errorDescription, 
      );
    }
  }

  Future<void> _onRefresh() async {
    ref.read(bookDetailsPageNotifierProvider(widget.params.bookId).notifier).fetch();
  }

  Future<void> _onSave() async {
    final BookDetailsPageState pageState = ref.watch(bookDetailsPageNotifierProvider(widget.params.bookId));
    final BookDetailsEntity book = pageState.book!;

    final String title = _titleController.text.trim();
    final String isbn10 = _isbn10Controller.text.trim();
    final String isbn13 = _isbn13Controller.text.trim();
    final int? edition = _editionController.text.trim().isNotEmpty
      ? int.parse(_editionController.text.trim())
      : null;
    final List<int> authorIds = _authorsNotifier.value.map((e) => e.id).toList();
    final List<int> categoryIds = _categoriesNotifier.value.map((e) => e.id).toList();
    final DateTime? publishDate = _publishDateNotifier.value;
    final List<int> publisherIds = _publishersNotifier.value.map((e) => e.id).toList();
    final DateTime receivedAt = _receivedAtNotifier.value;
    final bool bought = _boughtNotifier.value;

    try {
      Validator.validateBookUpdate(
        title: title,
        isbn10: isbn10,
        isbn13: isbn13,
        edition: edition,
        authorIds: authorIds,
        categoriesIds: categoryIds,
        publishDate: publishDate,
        publisherIds: publisherIds,
        receivedAt: receivedAt,
        bought: bought
      );
    } catch (e) {
      CoreUtils.showToast(
        context, 
        type: ToastType.error, 
        title: e.errorTitle, 
        description: e.errorDescription, 
      );
      return;
    }

    final List<int> beforeAuthorIds = book.authors.map((e) => e.id).toList();
    final List<int> beforeCategoryIds = book.categories.map((e) => e.id).toList();
    final List<int> beforePublisherIds = book.publishers.map((e) => e.id).toList();

    final bool replaceTitle = title != book.title;
    final bool replaceIsbn10 = isbn10 != (book.isbn10 ?? '');
    final bool replaceIsbn13 = isbn13 != (book.isbn13 ?? '');
    final bool replaceEdition = edition != book.edition;
    final bool replaceAuthors = !CoreUtils.intListsHaveSameContents(authorIds, beforeAuthorIds);
    final bool replaceCategories = !CoreUtils.intListsHaveSameContents(categoryIds, beforeCategoryIds);
    final bool replacePublishDate = publishDate != book.publishDate;
    final bool replacePublishers = !CoreUtils.intListsHaveSameContents(publisherIds, beforePublisherIds);
    final bool replaceReceivedAt = receivedAt != book.receivedAt;
    final bool replaceBought = bought != book.bought;

    Json bookJson = <String, dynamic>{
      if (replaceTitle) 'title' : "'$title'",
      if (replaceIsbn10) 'isbn_10' : "'$isbn10'",
      if (replaceIsbn13) 'isbn_13' : "'$isbn13'",
      if (replaceEdition) 'edition' : edition,
      if (replacePublishDate) 'publish_date' : publishDate != null
        ? "'${ publishDate.toIso8601String() }'"
        : null,
      if (replaceReceivedAt) 'received_at' : "'${ receivedAt.toIso8601String() }'",
      if (replaceBought) 'bought' : bought ? 1 : 0
    };

    final (List<int> removeAuthorIds, List<int> addAuthorIds) authorDiffs = CoreUtils.findUniqueElements(beforePublisherIds, publisherIds);
    final (List<int> removeCategoryIds, List<int> addCategoryIds) categoryDiffs = CoreUtils.findUniqueElements(beforeCategoryIds, categoryIds);
    final (List<int> removePublisherIds, List<int> addPublisherIds) publisherDiffs = CoreUtils.findUniqueElements(beforePublisherIds, publisherIds);

    if (bookJson.isEmpty && !replaceAuthors && !replaceCategories && !replacePublishers) return;

    final BookUpdateBookUsecase bookUpdateBookUsecase = ref.read(bookUpdateBookUsecaseProvider);
    final BookUpdateBookUsecaseParams bookUpdateBookUsecaseParams = BookUpdateBookUsecaseParams(
      bookId: book.id,
      bookJson: bookJson,
      removeAuthorIds: authorDiffs.$1,
      addAuthorIds: authorDiffs.$2,
      removeCategoryIds: categoryDiffs.$1,
      addCategoryIds: categoryDiffs.$2,
      removePublisherIds: publisherDiffs.$1,
      addPublisherIds: publisherDiffs.$2
    );
    final Result<void> bookUpdateBookUsecaseResult = await bookUpdateBookUsecase.call(bookUpdateBookUsecaseParams);

    bookUpdateBookUsecaseResult.fold<void>(
      onSuccess: (void _) {
        ref.read(bookDetailsPageNotifierProvider(widget.params.bookId).notifier).replace(
          BookDetailsEntity(
            id: book.id, 
            title: replaceTitle ? title : book.title,
            isbn10: replaceIsbn10 ? isbn10 : book.isbn10,
            isbn13: replaceIsbn13 ? isbn13 : book.isbn13,
            edition: replaceEdition ? edition : book.edition,
            publishDate: replacePublishDate ? publishDate : book.publishDate,
            bought: replaceBought ? bought : book.bought,
            receivedAt: replaceReceivedAt ? receivedAt : book.receivedAt,
            publishers: replacePublishers ? _publishersNotifier.value : book.publishers,
            categories: replaceCategories ? _categoriesNotifier.value : book.categories,
            authors: replaceAuthors ? _authorsNotifier.value : book.authors
          )
        );

        CoreUtils.showToast(
          context, 
          type: ToastType.success, 
          title: 'Erfolgreich aktualisiert.',
          description: 'Das Buch wurde erfolgreich aktualisiert.' 
        );
      },
      onFailure: (Object error, StackTrace stackTrace) {
        final ErrorDetails errorDetails = ErrorDetails(
          error: error, 
          stackTrace: stackTrace
        );
        CoreUtils.showToast(
          context, 
          type: ToastType.error, 
          title: errorDetails.errorTitle, 
          description: errorDetails.errorDescription, 
        );
      }
    );
  }

  Future<void> _onDelete() async {
    final bool? success = await showHBMessageBox(
      context, 
      'Dieses Buch wirklich löschen?', 
      'Wenn Sie dieses Buch löschen, werden alle damit verbundenen Daten ebenfalls gelöscht. Dieser Vorgang kann nicht rückgängig gemacht werden.',
      'Löschen',
      onPressed: () async {
        final BookDeleteBookUsecase bookDeleteBookUsecase = ref.read(bookDeleteBookUsecaseProvider);
        final BookDeleteBookUsecaseParams bookDeleteBookUsecaseParams = BookDeleteBookUsecaseParams(bookId: widget.params.bookId);
        final Result<void> bookDeleteBookUsecaseResult = await bookDeleteBookUsecase.call(bookDeleteBookUsecaseParams);

        return bookDeleteBookUsecaseResult.fold<bool>(
          onSuccess: (void _) => true,
          onFailure: (Object error, StackTrace stackTrace) {
            final ErrorDetails errorDetails = ErrorDetails(
              error: error, 
              stackTrace: stackTrace
            );
            CoreUtils.showToast(
              context, 
              type: ToastType.error, 
              title: errorDetails.errorTitle, 
              description: errorDetails.errorDescription, 
            );
            return false;
          }
        );
      }
    );

    if (mounted && context.canPop() && (success ?? false)) context.pop(true);
  }

  void _handlePublishDateChanged(DateTime newDate) {
    _publishDateNotifier.value = newDate;
  }

  void _handleReceivedAtDateChanged(DateTime newDate) {
    _receivedAtNotifier.value = newDate;
  }

  void _handleBoughtChanged(bool? newBought) {
    _boughtNotifier.value = newBought ?? false;
  }

  Future<void> _handleEditAuthors() async {
    List<CreateBookAuthor>? newAuthors = await showAuthorsSelectionDialog(
      context: context, 
      authors: _authorsNotifier.value.map((e)
        => CreateBookAuthor(
          id: e.id, 
          firstName: e.firstName, 
          lastName: e.lastName
        )).toList()
    );

    if (newAuthors != null) {
      _authorsNotifier.value = newAuthors.map((e)
        => BookDetailsAuthorEntity(
          id: e.id, 
          title: e.title,
          firstName: e.firstName, 
          lastName: e.lastName
        )).toList();
    }
  }

  Future<void> _handleEditCategories() async {
    List<CreateBookCategory>? newCategories = await showCategoriesSelectionDialog(
      context: context, 
      categories: _categoriesNotifier.value.map((e)
        => CreateBookCategory(
          id: e.id, 
          name: e.name
        )).toList()
    );

    if (newCategories != null) {
      _categoriesNotifier.value = newCategories.map((e)
        => BookDetailsCategoryEntity(
          id: e.id, 
          name: e.name
        )).toList();
    }
  }

  Future<void> _handleEditPublishers() async {
    List<CreateBookPublisher>? newPublishers = await showPublishersSelectionDialog(
      context: context, 
      publishers: _publishersNotifier.value.map((e)
        => CreateBookPublisher(
          id: e.id, 
          name: e.name,
          city: e.city
        )).toList()
    );

    if (newPublishers != null) {
      _publishersNotifier.value = newPublishers.map((e)
        => BookDetailsPublisherEntity(
          id: e.id, 
          name: e.name,
          city: e.city
        )).toList();
    }
  }

  @override
  void initState() {
    super.initState();

    CoreUtils.postFrameCall(() {
      ref.read(bookDetailsPageNotifierProvider(widget.params.bookId).notifier).fetch();
    });
  }

  @override
  Widget build(BuildContext context) {

    final BookDetailsPageState pageState = ref.watch(bookDetailsPageNotifierProvider(widget.params.bookId));

    if (pageState.hasBook) {
      _titleController = useTextEditingController(text: pageState.book!.title);
      _isbn10Controller = useTextEditingController(text: pageState.book!.isbn10);
      _isbn13Controller = useTextEditingController(text: pageState.book!.isbn13);
      _editionController = useTextEditingController(text: pageState.book!.edition?.toString());
      _authorsNotifier = useState<List<BookDetailsAuthorEntity>>(pageState.book!.authors);
      _categoriesNotifier = useState<List<BookDetailsCategoryEntity>>(pageState.book!.categories);
      _publishDateNotifier = useState<DateTime?>(pageState.book!.publishDate);
      _publishersNotifier = useState<List<BookDetailsPublisherEntity>>(pageState.book!.publishers);
      _receivedAtNotifier = useState<DateTime>(pageState.book!.receivedAt);
      _boughtNotifier = useState<bool>(pageState.book!.bought ?? false);
    }

    ref.listen<BookDetailsPageState>(
      bookDetailsPageNotifierProvider(widget.params.bookId), 
      _onDetailsStateUpdate
    );
    
    return HBScaffold(
      appBar: HBAppBar(
        context: context,
        title: 'Details',
        backButton: const HBAppBarBackButton(),
        actionButtons: [
          HBAppBarButton(
            onPressed: _onRefresh,
            icon: HBIcons.arrowPath,
            isEnabled: !pageState.isLoading
          ),
          HBAppBarButton(
            onPressed: _onSave,
            icon: HBIcons.cloudArrowUp,
            isEnabled: pageState.hasBook,
          ),
          HBAppBarButton(
            onPressed: _onDelete,
            icon: HBIcons.trash,
            isEnabled: pageState.hasBook
          )
        ]
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: pageState.hasBook
              ? SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: HBSpacing.lg,
                  right: context.rightPadding + HBSpacing.lg,
                  top: HBSpacing.lg
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Allgemeine Details',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: HBTypography.base.copyWith(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: HBColors.gray900
                      )
                    ),
                    const HBGap.xl(),
                    Row(
                      children: [
                        Expanded(
                          child: HBTextField(
                            title: 'Titel',
                            controller: _titleController,
                            icon: HBIcons.home
                          )
                        ),
                        const HBGap.xl(),
                        Expanded(
                          child: HBTextField(
                            title: 'ISBN-10',
                            controller: _isbn10Controller,
                            icon: HBIcons.home
                          )
                        ),
                        const HBGap.xl(),
                        Expanded(
                          child: HBTextField(
                            title: 'ISBN-13',
                            controller: _isbn13Controller,
                            icon: HBIcons.home
                          )
                        )
                      ]
                    ),
                    const HBGap.xl(),
                    Row(
                      children: [
                        Expanded(
                          child: HBTextField(
                            title: 'Edition',
                            inputType: TextInputType.number,
                            controller: _editionController,
                            icon: HBIcons.home
                          )
                        ),
                        const HBGap.xl(),
                        const Spacer(),
                        const HBGap.xl(),
                        const Spacer()
                      ]
                    ),
                    const HBGap.xl(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Autoren',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: HBTypography.base.copyWith(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w400,
                                        color: HBColors.gray900
                                      )
                                    )
                                  ),
                                  const HBGap.md(),
                                  HBLightButton(
                                    onPressed: _handleEditAuthors,
                                    isEnabled: pageState.hasBook,
                                    textAlign: TextAlign.end,
                                    title: 'Bearbeiten'
                                  )
                                ]
                              ),
                              const HBGap.md(),
                              Conditional.single(
                                condition: _authorsNotifier.value.isNotEmpty,
                                widget: HBChips(
                                  chips: List.generate(_authorsNotifier.value.length, (int index) {
                                    final BookDetailsAuthorEntity author = _authorsNotifier.value[index];
                                    return HBChip(
                                      text: '${ author.title != null ? '${ author.title} ' : '' } ${ author.firstName } ${ author.lastName }', 
                                      color: HBColors.gray900
                                    );
                                  })
                                ),
                                fallback: Text(
                                  'Keine Autoren gewählt',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: HBTypography.base.copyWith(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600
                                  )
                                )
                              )
                            ]
                          )
                        ),
                        const HBGap.xl(),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Kategorien',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: HBTypography.base.copyWith(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w400,
                                        color: HBColors.gray900
                                      )
                                    )
                                  ),
                                  const HBGap.md(),
                                  HBLightButton(
                                    onPressed: _handleEditCategories,
                                    isEnabled: pageState.hasBook,
                                    textAlign: TextAlign.end,
                                    title: 'Bearbeiten'
                                  )
                                ]
                              ),
                              const HBGap.md(),
                              Conditional.single(
                                condition: _categoriesNotifier.value.isNotEmpty,
                                widget: HBChips(
                                  chips: List.generate(_categoriesNotifier.value.length, (int index) {
                                    final BookDetailsCategoryEntity category = _categoriesNotifier.value[index];
                                    return HBChip(
                                      text: category.name, 
                                      color: HBColors.gray900
                                    );
                                  })
                                ),
                                fallback: Text(
                                  'Keine Kategorien gewählt',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: HBTypography.base.copyWith(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600
                                  )
                                )
                              )
                            ]
                          )
                        ),
                        const HBGap.xl(),
                        const Spacer()
                      ]
                    ),
                    const HBGap.xxl(),
                    Text(
                      'Verlagsinformationen',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: HBTypography.base.copyWith(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: HBColors.gray900
                      )
                    ),
                    const HBGap.xl(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: HBDateButton(
                            onChanged: _handlePublishDateChanged,
                            title: 'Veröffentlichung',
                            dateTime: _publishDateNotifier.value
                          )
                        ),
                        const HBGap.xl(),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Verläge',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: HBTypography.base.copyWith(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w400,
                                        color: HBColors.gray900
                                      )
                                    )
                                  ),
                                  const HBGap.md(),
                                  HBLightButton(
                                    onPressed: _handleEditPublishers,
                                    isEnabled: pageState.hasBook,
                                    textAlign: TextAlign.end,
                                    title: 'Bearbeiten'
                                  )
                                ]
                              ),
                              const HBGap.md(),
                              Conditional.single(
                                condition: _publishersNotifier.value.isNotEmpty,
                                widget: HBChips(
                                  chips: List.generate(_publishersNotifier.value.length, (int index) {
                                    final BookDetailsPublisherEntity publisher = _publishersNotifier.value[index];
                                    return HBChip(
                                      text: '${ publisher.name }${ publisher.city != null ? ' (${ publisher.city })' : '' }', 
                                      color: HBColors.gray900
                                    );
                                  })
                                ),
                                fallback: Text(
                                  'Keine Verläge gewählt',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: HBTypography.base.copyWith(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600
                                  )
                                )
                              )
                            ]
                          )
                        ),
                        const HBGap.xl(),
                        const Spacer()
                      ]
                    ),
                    const HBGap.xxl(),
                    Text(
                      'Anlageinformationen',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: HBTypography.base.copyWith(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: HBColors.gray900
                      )
                    ),
                    const HBGap.xl(),
                    Row(
                      children: [
                        Expanded(
                          child: HBDateButton(
                            onChanged: _handleReceivedAtDateChanged,
                            title: 'Erhalten',
                            dateTime: _receivedAtNotifier.value
                          )
                        ),
                        const HBGap.xl(),
                        Expanded(
                          child: Center(
                            child: HBCheckbox(
                              onChanged: _handleBoughtChanged,
                              text: 'Ist gekauft?',
                              isSelected: _boughtNotifier.value
                            )
                          )
                        ),
                        const Spacer()
                      ]
                    )
                  ]
                )
              )
              : pageState.hasError
                ? Center(
                  child: Text(
                    pageState.error!.errorDescription,
                    textAlign: TextAlign.center,
                    style: HBTypography.base.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: HBColors.gray900
                    ),
                  )
                )
                : const SizedBox.shrink()
          ),
          const Divider(),
          Expanded(
            flex: 2,
            child: BookBorrowsTable(bookId: widget.params.bookId)
          )
        ]
      )
    );
  }
}
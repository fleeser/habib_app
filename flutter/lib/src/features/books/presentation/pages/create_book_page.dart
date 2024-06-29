import 'package:flutter/material.dart';

import 'package:flutter_conditional/flutter_conditional.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:habib_app/core/common/widgets/hb_chip.dart';
import 'package:habib_app/core/common/models/error_details.dart';
import 'package:habib_app/core/extensions/object_extension.dart';
import 'package:habib_app/core/services/routes.dart';
import 'package:habib_app/core/utils/core_utils.dart';
import 'package:habib_app/core/utils/enums/toast_type.dart';
import 'package:habib_app/core/utils/result.dart';
import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/core/utils/validator.dart';
import 'package:habib_app/src/features/books/domain/usecases/book_create_book_usecase.dart';
import 'package:habib_app/src/features/publishers/presentation/widgets/publishers_selection_dialog.dart';
import 'package:habib_app/src/features/authors/presentation/widgets/authors_selection_dialog.dart';
import 'package:habib_app/src/features/categories/presentation/widgets/categories_selection_dialog.dart';
import 'package:habib_app/core/common/widgets/hb_light_button.dart';
import 'package:habib_app/core/res/theme/colors/hb_colors.dart';
import 'package:habib_app/core/res/theme/typography/hb_typography.dart';
import 'package:habib_app/core/common/widgets/hb_checkbox.dart';
import 'package:habib_app/core/common/widgets/hb_date_button.dart';
import 'package:habib_app/core/common/widgets/hb_dialog.dart';
import 'package:habib_app/core/common/widgets/hb_gap.dart';
import 'package:habib_app/core/common/widgets/hb_text_field.dart';
import 'package:habib_app/core/res/hb_icons.dart';

class CreateBookAuthor {

  final int id;
  final String? title;
  final String firstName;
  final String lastName;

  const CreateBookAuthor({
    required this.id,
    this.title,
    required this.firstName,
    required this.lastName
  });

  String toOneLine() {
    return '${ title != null ? '$title ' : '' } $firstName $lastName';
  }
}

class CreateBookCategory {

  final int id;
  final String name;

  const CreateBookCategory({
    required this.id,
    required this.name
  });

  String toOneLine() {
    return name;
  }
}

class CreateBookPublisher {

  final int id;
  final String name;
  final String? city;

  const CreateBookPublisher({
    required this.id,
    required this.name,
    this.city
  });

  String toOneLine() {
    return '$name${ city != null ? ' ($city)' : '' }';
  }
}

class CreateBookPage extends StatefulHookConsumerWidget {
  
  const CreateBookPage({ super.key });

  @override
  ConsumerState<CreateBookPage> createState() => _CreateBookPageState();
}

class _CreateBookPageState extends ConsumerState<CreateBookPage> {

  late TextEditingController _titleController;
  late TextEditingController _isbn10Controller;
  late TextEditingController _isbn13Controller;
  late ValueNotifier<List<CreateBookAuthor>> _authorsNotifier;
  late ValueNotifier<List<CreateBookCategory>> _categoriesNotifier;
  late TextEditingController _editionController;
  late ValueNotifier<DateTime?> _publishDateNotifier;
  late ValueNotifier<List<CreateBookPublisher>> _publishersNotifier;
  late ValueNotifier<bool> _boughtNotifier;
  late ValueNotifier<DateTime> _receivedAtNotifier;

  Future<void> _handleCreate() async {
    final String title = _titleController.text.trim();
    final String isbn10 = _isbn10Controller.text.trim();
    final String isbn13 = _isbn13Controller.text.trim();
    final List<int> authorIds = _authorsNotifier.value.map((e) => e.id).toList();
    final List<int> categoriesIds = _categoriesNotifier.value.map((e) => e.id).toList();
    final int? edition = _editionController.text.trim().isNotEmpty 
      ? int.parse(_editionController.text.trim())
      : null;
    final DateTime? publishDate = _publishDateNotifier.value;
    final List<int> publisherIds = _publishersNotifier.value.map((e) => e.id).toList();
    final bool bought = _boughtNotifier.value;
    final DateTime receivedAt = _receivedAtNotifier.value;

    try {
      Validator.validateBookCreate(
        title: title,
        isbn10: isbn10,
        isbn13: isbn13,
        authorIds: authorIds,
        categoriesIds: categoriesIds,
        edition: edition,
        publishDate: publishDate,
        publisherIds: publisherIds,
        bought: bought,
        receivedAt: receivedAt
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

    Json bookJson = <String, dynamic>{
      'title' : "'$title'",
      'isbn_10' : "'$isbn10'",
      'isbn_13' : "'$isbn13'",
      'edition' : edition,
      'publish_date' : publishDate != null
        ? "'${ publishDate.toIso8601String() }'"
        : null,
      'bought' : bought ? 1 : 0,
      'received_at' : "'${ receivedAt.toIso8601String() }'"
    };

    final BookCreateBookUsecase bookCreateBookUsecase = ref.read(bookCreateBookUsecaseProvider);
    final BookCreateBookUsecaseParams bookCreateBookUsecaseParams = BookCreateBookUsecaseParams(
      bookJson: bookJson,
      authorIds: authorIds,
      categoryIds: categoriesIds,
      publisherIds: publisherIds
    );
    final Result<int> bookCreateBookUsecaseResult = await bookCreateBookUsecase.call(bookCreateBookUsecaseParams);

    bookCreateBookUsecaseResult.fold<void>(
      onSuccess: (int bookId) async {
        CoreUtils.showToast(
          context, 
          type: ToastType.success, 
          title: 'Erfolgreich angelegt.',
          description: 'Das Buch wurde erfolgreich angelegt.' 
        );

        if (!mounted) return;

        context.pop();

        await BookDetailsRoute(bookId: bookId).push(context);
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
      authors: _authorsNotifier.value
    );

    if (newAuthors != null) _authorsNotifier.value = newAuthors;
  }

  Future<void> _handleEditCategories() async {
    List<CreateBookCategory>? newCategories = await showCategoriesSelectionDialog(
      context: context, 
      categories: _categoriesNotifier.value
    );

    if (newCategories != null) _categoriesNotifier.value = newCategories;
  }

  Future<void> _handleEditPublishers() async {
    List<CreateBookPublisher>? newPublishers = await showPublishersSelectionDialog(
      context: context, 
      publishers: _publishersNotifier.value
    );

    if (newPublishers != null) _publishersNotifier.value = newPublishers;
  }
  
  @override
  Widget build(BuildContext context) {

    _titleController = useTextEditingController();
    _isbn10Controller = useTextEditingController();
    _isbn13Controller = useTextEditingController();
    _authorsNotifier = useState<List<CreateBookAuthor>>(<CreateBookAuthor>[]);
    _categoriesNotifier = useState<List<CreateBookCategory>>(<CreateBookCategory>[]);
    _editionController = useTextEditingController();
    _publishDateNotifier = useState<DateTime?>(null);
    _publishersNotifier = useState<List<CreateBookPublisher>>(<CreateBookPublisher>[]);
    _boughtNotifier = useState<bool>(false);
    _receivedAtNotifier = useState<DateTime>(DateTime.now());

    return HBDialog<int>(
      title: 'Neues Buch',
      actionButton: HBDialogActionButton(
        onPressed: _handleCreate,
        title: 'Erstellen'
      ),
      children: [
        const HBDialogSection(
          title: 'Allgemeine Details',
          isFirstSection: true
        ),
        Row(
          children: [
            Expanded(
              child: HBTextField(
                controller: _titleController,
                icon: HBIcons.academicCap,
                title: 'Titel'
              )
            ),
            const HBGap.lg(),
            Expanded(
              child: HBTextField(
                controller: _editionController,
                inputType: TextInputType.number,
                icon: HBIcons.user,
                title: 'Edition'
              )
            )
          ]
        ),
        const HBGap.lg(),
        Row(
          children: [
            Expanded(
              child: HBTextField(
                controller: _isbn10Controller,
                icon: HBIcons.user,
                title: 'ISBN-10'
              )
            ),
            const HBGap.lg(),
            Expanded(
              child: HBTextField(
                controller: _isbn13Controller,
                icon: HBIcons.beaker,
                title: 'ISBN-13'
              )
            )
          ]
        ),
        const HBGap.lg(),
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
                        final CreateBookAuthor author = _authorsNotifier.value[index];
                        return HBChip(
                          text: author.toOneLine(), 
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
            const HBGap.lg(),
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
                        final CreateBookCategory category = _categoriesNotifier.value[index];
                        return HBChip(
                          text: category.toOneLine(), 
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
            )
          ]
        ),
        const HBDialogSection(title: 'Verlagsinformationen'),
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
            const HBGap.lg(),
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
                        final CreateBookPublisher publisher = _publishersNotifier.value[index];
                        return HBChip(
                          text: publisher.toOneLine(), 
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
            )
          ]
        ),
        const HBDialogSection(title: 'Anlageinformationen'),
        Row(
          children: [
            Expanded(
              child: HBDateButton(
                onChanged: _handleReceivedAtDateChanged,
                title: 'Erhalten',
                dateTime: _receivedAtNotifier.value
              )
            ),
            const HBGap.lg(),
            Expanded(
              child: Center(
                child: HBCheckbox(
                  onChanged: _handleBoughtChanged,
                  text: 'Ist gekauft?',
                  isSelected: _boughtNotifier.value
                )
              )
            )
          ]
        )
      ]
    );
  }
}
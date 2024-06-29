import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:habib_app/src/features/authors/domain/entities/author_entity.dart';
import 'package:habib_app/src/features/authors/presentation/app/authors_page_notifier.dart';
import 'package:habib_app/core/common/widgets/hb_button.dart';
import 'package:habib_app/core/common/widgets/hb_gap.dart';
import 'package:habib_app/core/common/widgets/hb_selection_dialog.dart';
import 'package:habib_app/core/common/widgets/hb_table.dart';
import 'package:habib_app/core/common/widgets/hb_text_field.dart';
import 'package:habib_app/core/extensions/context_extension.dart';
import 'package:habib_app/core/extensions/object_extension.dart';
import 'package:habib_app/core/res/hb_icons.dart';
import 'package:habib_app/core/res/theme/spacing/hb_spacing.dart';
import 'package:habib_app/core/services/routes.dart';
import 'package:habib_app/core/utils/core_utils.dart';
import 'package:habib_app/core/utils/enums/toast_type.dart';
import 'package:habib_app/src/features/books/presentation/pages/create_book_page.dart';

Future<List<CreateBookAuthor>?> showAuthorsSelectionDialog({
  required BuildContext context,
  required List<CreateBookAuthor> authors
}) async {
  return await showHBSelectionDialog<List<CreateBookAuthor>>(
    context: context,
    title: 'Autoren wählen',
    content: AuthorsSelectionDialog(authors: authors)
  );
}

class AuthorsSelectionDialog extends StatefulHookConsumerWidget {

  final List<CreateBookAuthor> authors;

  const AuthorsSelectionDialog({ 
    super.key,
    required this.authors
  });

  @override
  ConsumerState<AuthorsSelectionDialog> createState() => _AuthorsSelectionDialogState();
}

class _AuthorsSelectionDialogState extends ConsumerState<AuthorsSelectionDialog> {

  late ValueNotifier<List<CreateBookAuthor>> _authorsNotifier;

  final ScrollController _scrollController = ScrollController();

  late TextEditingController _searchController;

  void _onPageStateUpdate(AuthorsPageState? _, AuthorsPageState next) {
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
      ref.read(authorsPageNotifierProvider.notifier).fetchNextPage(_searchText);
    }
  }

  HBTableStatus get _tableStatus {
    final AuthorsPageState pageState = ref.read(authorsPageNotifierProvider);
    if (pageState.hasAuthors) return HBTableStatus.data;
    if (pageState.hasError || !pageState.hasAuthors) return HBTableStatus.text;
    return HBTableStatus.loading;
  }

  String? get _tableText {
    final AuthorsPageState pageState = ref.read(authorsPageNotifierProvider);
    if (!pageState.isLoading && !pageState.hasError && !pageState.hasAuthors) return 'Keine Autoren gefunden.';
    if (pageState.hasError) return 'Ein Fehler ist aufgetreten.';
    return null;
  }

  String get _searchText {
    return _searchController.text.trim();
  }

  Future<void> _onAuthorPressed(int authorId) async {
    await AuthorDetailsRoute(authorId: authorId).push(context);
  }

  Future<void> _onSearchChanged(String _) async {
    await ref.read(authorsPageNotifierProvider.notifier).refresh(_searchText);
  }

  Future<void> _onRefresh() async {
    await ref.read(authorsPageNotifierProvider.notifier).refresh(_searchText);
  }

  void _onRowPressed(AuthorEntity selectedAuthor) async {
    if (_authorsNotifier.value.map((CreateBookAuthor author) => author.id).contains(selectedAuthor.id)) {
      _authorsNotifier.value = _authorsNotifier.value.where((CreateBookAuthor author) => author.id != selectedAuthor.id).toList();
    } else {
      final CreateBookAuthor newAuthor = CreateBookAuthor(
        id: selectedAuthor.id, 
        title: selectedAuthor.title,
        firstName: selectedAuthor.firstName,
        lastName: selectedAuthor.lastName
      );
      _authorsNotifier.value = <CreateBookAuthor>[ ..._authorsNotifier.value, newAuthor ];
    }
  }

  void _cancel() {
    context.pop();
  }

  void _onChoose() {
    context.pop<List<CreateBookAuthor>>(_authorsNotifier.value);
  }

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    CoreUtils.postFrameCall(() {
      ref.read(authorsPageNotifierProvider.notifier).fetchNextPage(_searchText);
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

    _authorsNotifier = useState<List<CreateBookAuthor>>(widget.authors);

    final AuthorsPageState pageState = ref.watch(authorsPageNotifierProvider);

    _searchController = useTextEditingController();

    ref.listen<AuthorsPageState>(
      authorsPageNotifierProvider,
      _onPageStateUpdate
    );

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: HBSpacing.lg,
            right: context.rightPadding + HBSpacing.lg,
            top: HBSpacing.lg
          ),
          child: Row(
            children: [
              Expanded(
                child: HBTextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  icon: HBIcons.magnifyingGlass,
                  hint: 'Name'
                )
              ),
              const HBGap.lg(),
              HBButton.shrinkFill(
                onPressed: _onRefresh,
                icon: HBIcons.arrowPath
              )
            ]
          )
        ),
        Expanded(
          child: HBTable(
            onPressed: (int index) => _onRowPressed(pageState.authors[index]),
            status: _tableStatus,
            padding: EdgeInsets.only(
              left: HBSpacing.lg,
              right: context.rightPadding + HBSpacing.lg,
              bottom: context.bottomPadding + HBSpacing.lg,
              top: HBSpacing.xxl
            ),
            controller: _scrollController,
            tableWidth: 800.0 - 4.0 * HBSpacing.lg,
            columnLength: 2,
            fractions: const [ 0.95, 0.05 ],
            titles: const [ 'Name', '' ],
            items: List.generate(pageState.authors.length, (int index) {
              final AuthorEntity author = pageState.authors[index];
              final bool isSelected = _authorsNotifier.value.map((CreateBookAuthor author) => author.id).contains(author.id);
              return [
                HBTableText(
                  onPressed: () => _onAuthorPressed(author.id),
                  text: '${ author.title != null ? '${ author.title } ' : '' }${ author.firstName } ${ author.lastName }'
                ),
                HBTableRadioIndicator(isSelected: isSelected)
              ];
            }),
            text: _tableText
          )
        ),
        const HBGap.lg(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: HBSpacing.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              HBButton.shrinkFill(
                onPressed: _onChoose,
                title: 'Wählen'
              ),
              const HBGap.md(),
              HBButton.shrinkOutline(
                onPressed: _cancel,
                title: 'Abbrechen'
              )
            ]
          )
        )
      ]
    );
  }
}
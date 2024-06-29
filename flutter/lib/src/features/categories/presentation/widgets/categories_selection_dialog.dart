import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
import 'package:habib_app/src/features/categories/domain/entities/category_entity.dart';
import 'package:habib_app/src/features/categories/presentation/app/categories_page_notifier.dart';

Future<List<CreateBookCategory>?> showCategoriesSelectionDialog({
  required BuildContext context,
  required List<CreateBookCategory> categories
}) async {
  return await showHBSelectionDialog<List<CreateBookCategory>>(
    context: context,
    title: 'Kategorien wählen',
    content: CategoriesSelectionDialog(categories: categories)
  );
}

class CategoriesSelectionDialog extends StatefulHookConsumerWidget {

  final List<CreateBookCategory> categories;

  const CategoriesSelectionDialog({ 
    super.key,
    required this.categories
  });

  @override
  ConsumerState<CategoriesSelectionDialog> createState() => _CategoriesSelectionDialogState();
}

class _CategoriesSelectionDialogState extends ConsumerState<CategoriesSelectionDialog> {

  late ValueNotifier<List<CreateBookCategory>> _categoriesNotifier;

  final ScrollController _scrollController = ScrollController();

  late TextEditingController _searchController;

  void _onPageStateUpdate(CategoriesPageState? _, CategoriesPageState next) {
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
      ref.read(categoriesPageNotifierProvider.notifier).fetchNextPage(_searchText);
    }
  }

  HBTableStatus get _tableStatus {
    final CategoriesPageState pageState = ref.read(categoriesPageNotifierProvider);
    if (pageState.hasCategories) return HBTableStatus.data;
    if (pageState.hasError || !pageState.hasCategories) return HBTableStatus.text;
    return HBTableStatus.loading;
  }

  String? get _tableText {
    final CategoriesPageState pageState = ref.read(categoriesPageNotifierProvider);
    if (!pageState.isLoading && !pageState.hasError && !pageState.hasCategories) return 'Keine Kategorien gefunden.';
    if (pageState.hasError) return 'Ein Fehler ist aufgetreten.';
    return null;
  }

  String get _searchText {
    return _searchController.text.trim();
  }

  Future<void> _onCategoryPressed(int categoryId) async {
    await CategoryDetailsRoute(categoryId: categoryId).push(context);
  }

  Future<void> _onSearchChanged(String _) async {
    await ref.read(categoriesPageNotifierProvider.notifier).refresh(_searchText);
  }

  Future<void> _onRefresh() async {
    await ref.read(categoriesPageNotifierProvider.notifier).refresh(_searchText);
  }

  void _onRowPressed(CategoryEntity selectedCategory) async {
    if (_categoriesNotifier.value.map((CreateBookCategory category) => category.id).contains(selectedCategory.id)) {
      _categoriesNotifier.value = _categoriesNotifier.value.where((CreateBookCategory category) => category.id != selectedCategory.id).toList();
    } else {
      final CreateBookCategory newCategory = CreateBookCategory(
        id: selectedCategory.id, 
        name: selectedCategory.name
      );
      _categoriesNotifier.value = <CreateBookCategory>[ ..._categoriesNotifier.value, newCategory ];
    }
  }

  void _cancel() {
    context.pop();
  }

  void _onChoose() {
    context.pop<List<CreateBookCategory>>(_categoriesNotifier.value);
  }

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    CoreUtils.postFrameCall(() {
      ref.read(categoriesPageNotifierProvider.notifier).fetchNextPage(_searchText);
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

    _categoriesNotifier = useState<List<CreateBookCategory>>(widget.categories);

    final CategoriesPageState pageState = ref.watch(categoriesPageNotifierProvider);

    _searchController = useTextEditingController();

    ref.listen<CategoriesPageState>(
      categoriesPageNotifierProvider,
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
            onPressed: (int index) => _onRowPressed(pageState.categories[index]),
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
            items: List.generate(pageState.categories.length, (int index) {
              final CategoryEntity category = pageState.categories[index];
              final bool isSelected = _categoriesNotifier.value.map((CreateBookCategory category) => category.id).contains(category.id);
              return [
                HBTableText(
                  onPressed: () => _onCategoryPressed(category.id),
                  text: category.name
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
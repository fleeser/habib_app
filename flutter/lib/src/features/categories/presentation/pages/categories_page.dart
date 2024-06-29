import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:habib_app/core/extensions/object_extension.dart';
import 'package:habib_app/core/services/routes.dart';
import 'package:habib_app/src/features/categories/presentation/app/categories_page_notifier.dart';
import 'package:habib_app/core/common/widgets/hb_table.dart';
import 'package:habib_app/src/features/categories/domain/entities/category_entity.dart';
import 'package:habib_app/core/common/widgets/hb_app_bar.dart';
import 'package:habib_app/core/common/widgets/hb_button.dart';
import 'package:habib_app/core/common/widgets/hb_gap.dart';
import 'package:habib_app/core/common/widgets/hb_scaffold.dart';
import 'package:habib_app/core/common/widgets/hb_text_field.dart';
import 'package:habib_app/core/extensions/context_extension.dart';
import 'package:habib_app/core/res/hb_icons.dart';
import 'package:habib_app/core/res/theme/spacing/hb_spacing.dart';
import 'package:habib_app/core/utils/constants/hb_ui_constants.dart';
import 'package:habib_app/core/utils/core_utils.dart';
import 'package:habib_app/core/utils/enums/toast_type.dart';

class CategoriesPage extends StatefulHookConsumerWidget {

  const CategoriesPage({ super.key });

  @override
  ConsumerState<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends ConsumerState<CategoriesPage> {

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

  Future<void> _onCreateCategory() async {
    final int? categoryId = await const CreateCategoryRoute().push(context);
    if (categoryId != null && mounted) await CategoryDetailsRoute(categoryId: categoryId).push(context);
  }

  Future<void> _onSearchChanged(String _) async {
    await ref.read(categoriesPageNotifierProvider.notifier).refresh(_searchText);
  }

  Future<void> _onRefresh() async {
    await ref.read(categoriesPageNotifierProvider.notifier).refresh(_searchText);
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

    final CategoriesPageState pageState = ref.watch(categoriesPageNotifierProvider);

    _searchController = useTextEditingController();

    ref.listen<CategoriesPageState>(
      categoriesPageNotifierProvider,
      _onPageStateUpdate
    );

    return HBScaffold(
      appBar: HBAppBar(
        context: context, 
        title: 'Kategorien'
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
                  hint: 'Name',
                  maxWidth: 500.0
                ),
                const HBGap.lg(),
                const Spacer(),
                HBButton.shrinkFill(
                  onPressed: _onCreateCategory,
                  icon: HBIcons.plus,
                  title: 'Neue Kategorie'
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
              onPressed: (int index) => _onCategoryPressed(pageState.categories[index].id),
              status: _tableStatus,
              padding: EdgeInsets.only(
                left: HBSpacing.lg,
                right: context.rightPadding + HBSpacing.lg,
                bottom: context.bottomPadding + HBSpacing.lg,
                top: HBSpacing.xxl
              ),
              controller: _scrollController,
              tableWidth: context.width - HBUIConstants.navigationRailWidth - context.rightPadding - 4.0 * HBSpacing.lg,
              columnLength: 1,
              fractions: const [ 1.0 ],
              titles: const [ 'Name' ],
              items: List.generate(pageState.categories.length, (int index) {
                final CategoryEntity category = pageState.categories[index];
                return [
                  HBTableText(text: category.name)
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
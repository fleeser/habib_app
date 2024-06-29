import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:habib_app/core/extensions/object_extension.dart';
import 'package:habib_app/src/features/authors/presentation/app/authors_page_notifier.dart';
import 'package:habib_app/src/features/authors/domain/entities/author_entity.dart';
import 'package:habib_app/core/common/widgets/hb_table.dart';
import 'package:habib_app/core/services/routes.dart';
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

class AuthorsPage extends StatefulHookConsumerWidget {

  const AuthorsPage({ super.key });

  @override
  ConsumerState<AuthorsPage> createState() => _AuthorsPageState();
}

class _AuthorsPageState extends ConsumerState<AuthorsPage> {

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

  Future<void> _onCreateAuthor() async {
    await const CreateAuthorRoute().push(context);
  }

  Future<void> _onSearchChanged(String _) async {
    await ref.read(authorsPageNotifierProvider.notifier).refresh(_searchText);
  }

  Future<void> _onRefresh() async {
    await ref.read(authorsPageNotifierProvider.notifier).refresh(_searchText);
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

    final AuthorsPageState pageState = ref.watch(authorsPageNotifierProvider);

    _searchController = useTextEditingController();

    ref.listen<AuthorsPageState>(
      authorsPageNotifierProvider,
      _onPageStateUpdate
    );

    return HBScaffold(
      appBar: HBAppBar(
        context: context, 
        title: 'Autoren'
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
                  onPressed: _onCreateAuthor,
                  icon: HBIcons.plus,
                  title: 'Neue/r Autor*in'
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
              onPressed: (int index) => _onAuthorPressed(pageState.authors[index].id),
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
              items: List.generate(pageState.authors.length, (int index) {
                final AuthorEntity author = pageState.authors[index];
                return [
                  HBTableText(text: '${ author.title != null ? '${ author.title } ' : '' }${ author.firstName } ${ author.lastName }')
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
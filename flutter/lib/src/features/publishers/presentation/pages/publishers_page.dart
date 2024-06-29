import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:habib_app/core/extensions/object_extension.dart';
import 'package:habib_app/src/features/publishers/domain/entities/publisher_entity.dart';
import 'package:habib_app/src/features/publishers/presentation/app/publishers_page_notifier.dart';
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

class PublishersPage extends StatefulHookConsumerWidget {

  const PublishersPage({ super.key });

  @override
  ConsumerState<PublishersPage> createState() => _PublishersPageState();
}

class _PublishersPageState extends ConsumerState<PublishersPage> {

  final ScrollController _scrollController = ScrollController();

  late TextEditingController _searchController;

  void _onPageStateUpdate(PublishersPageState? _, PublishersPageState next) {
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
      ref.read(publishersPageNotifierProvider.notifier).fetchNextPage(_searchText);
    }
  }

  HBTableStatus get _tableStatus {
    final PublishersPageState pageState = ref.read(publishersPageNotifierProvider);
    if (pageState.hasPublishers) return HBTableStatus.data;
    if (pageState.hasError || !pageState.hasPublishers) return HBTableStatus.text;
    return HBTableStatus.loading;
  }

  String? get _tableText {
    final PublishersPageState pageState = ref.read(publishersPageNotifierProvider);
    if (!pageState.isLoading && !pageState.hasError && !pageState.hasPublishers) return 'Keine Verlage gefunden.';
    if (pageState.hasError) return 'Ein Fehler ist aufgetreten.';
    return null;
  }

  String get _searchText {
    return _searchController.text.trim();
  }

  Future<void> _onPublisherPressed(int publisherId) async {
    await PublisherDetailsRoute(publisherId: publisherId).push(context);
  }

  Future<void> _onCreatePublisher() async {
    await const CreatePublisherRoute().push(context);
  }

  Future<void> _onSearchChanged(String _) async {
    await ref.read(publishersPageNotifierProvider.notifier).refresh(_searchText);
  }

  Future<void> _onRefresh() async {
    await ref.read(publishersPageNotifierProvider.notifier).refresh(_searchText);
  }

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    CoreUtils.postFrameCall(() {
      ref.read(publishersPageNotifierProvider.notifier).fetchNextPage(_searchText);
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

    final PublishersPageState pageState = ref.watch(publishersPageNotifierProvider);

    _searchController = useTextEditingController();

    ref.listen<PublishersPageState>(
      publishersPageNotifierProvider,
      _onPageStateUpdate
    );

    return HBScaffold(
      appBar: HBAppBar(
        context: context, 
        title: 'Verlage'
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
                  onPressed: _onCreatePublisher,
                  icon: HBIcons.plus,
                  title: 'Neuer Verlag'
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
              onPressed: (int index) => _onPublisherPressed(pageState.publishers[index].id),
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
              fractions: const [ 0.7, 0.3 ],
              titles: const [ 'Name', 'Stadt' ],
              items: List.generate(pageState.publishers.length, (int index) {
                final PublisherEntity publisher = pageState.publishers[index];
                return [
                  HBTableText(text: publisher.name),
                  HBTableText(text: publisher.city ?? '')
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
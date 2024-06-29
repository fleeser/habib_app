import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:habib_app/core/extensions/object_extension.dart';
import 'package:habib_app/core/common/widgets/hb_button.dart';
import 'package:habib_app/core/common/widgets/hb_gap.dart';
import 'package:habib_app/core/common/widgets/hb_selection_dialog.dart';
import 'package:habib_app/core/common/widgets/hb_table.dart';
import 'package:habib_app/core/common/widgets/hb_text_field.dart';
import 'package:habib_app/core/extensions/context_extension.dart';
import 'package:habib_app/src/features/publishers/domain/entities/publisher_entity.dart';
import 'package:habib_app/src/features/publishers/presentation/app/publishers_page_notifier.dart';
import 'package:habib_app/core/res/hb_icons.dart';
import 'package:habib_app/core/res/theme/spacing/hb_spacing.dart';
import 'package:habib_app/core/services/routes.dart';
import 'package:habib_app/core/utils/core_utils.dart';
import 'package:habib_app/core/utils/enums/toast_type.dart';
import 'package:habib_app/src/features/books/presentation/pages/create_book_page.dart';

Future<List<CreateBookPublisher>?> showPublishersSelectionDialog({
  required BuildContext context,
  required List<CreateBookPublisher> publishers
}) async {
  return await showHBSelectionDialog<List<CreateBookPublisher>>(
    context: context,
    title: 'Verläge wählen',
    content: PublishersSelectionDialog(publishers: publishers)
  );
}

class PublishersSelectionDialog extends StatefulHookConsumerWidget {

  final List<CreateBookPublisher> publishers;

  const PublishersSelectionDialog({ 
    super.key,
    required this.publishers
  });

  @override
  ConsumerState<PublishersSelectionDialog> createState() => _PublishersSelectionDialogState();
}

class _PublishersSelectionDialogState extends ConsumerState<PublishersSelectionDialog> {

  late ValueNotifier<List<CreateBookPublisher>> _publishersNotifier;

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
    if (!pageState.isLoading && !pageState.hasError && !pageState.hasPublishers) return 'Keine Verläge gefunden.';
    if (pageState.hasError) return 'Ein Fehler ist aufgetreten.';
    return null;
  }

  String get _searchText {
    return _searchController.text.trim();
  }

  Future<void> _onPublisherPressed(int publisherId) async {
    await PublisherDetailsRoute(publisherId: publisherId).push(context);
  }

  Future<void> _onSearchChanged(String _) async {
    await ref.read(publishersPageNotifierProvider.notifier).refresh(_searchText);
  }

  Future<void> _onRefresh() async {
    await ref.read(publishersPageNotifierProvider.notifier).refresh(_searchText);
  }

  void _onRowPressed(PublisherEntity selectedPublisher) async {
    if (_publishersNotifier.value.map((CreateBookPublisher publisher) => publisher.id).contains(selectedPublisher.id)) {
      _publishersNotifier.value = _publishersNotifier.value.where((CreateBookPublisher publisher) => publisher.id != selectedPublisher.id).toList();
    } else {
      final CreateBookPublisher newPublisher = CreateBookPublisher(
        id: selectedPublisher.id, 
        name: selectedPublisher.name,
        city: selectedPublisher.city
      );
      _publishersNotifier.value = <CreateBookPublisher>[ ..._publishersNotifier.value, newPublisher ];
    }
  }

  void _cancel() {
    context.pop();
  }

  void _onChoose() {
    context.pop<List<CreateBookPublisher>>(_publishersNotifier.value);
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

    _publishersNotifier = useState<List<CreateBookPublisher>>(widget.publishers);

    final PublishersPageState pageState = ref.watch(publishersPageNotifierProvider);

    _searchController = useTextEditingController();

    ref.listen<PublishersPageState>(
      publishersPageNotifierProvider,
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
            onPressed: (int index) => _onRowPressed(pageState.publishers[index]),
            status: _tableStatus,
            padding: EdgeInsets.only(
              left: HBSpacing.lg,
              right: context.rightPadding + HBSpacing.lg,
              bottom: context.bottomPadding + HBSpacing.lg,
              top: HBSpacing.xxl
            ),
            controller: _scrollController,
            tableWidth: 800.0 - 4.0 * HBSpacing.lg,
            columnLength: 3,
            fractions: const [ 0.55, 0.4, 0.05 ],
            titles: const [ 'Name', 'Stadt', '' ],
            items: List.generate(pageState.publishers.length, (int index) {
              final PublisherEntity publisher = pageState.publishers[index];
              final bool isSelected = _publishersNotifier.value.map((CreateBookPublisher publisher) => publisher.id).contains(publisher.id);
              return [
                HBTableText(
                  onPressed: () => _onPublisherPressed(publisher.id),
                  text: publisher.name
                ),
                HBTableText(text: publisher.city ?? ''),
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
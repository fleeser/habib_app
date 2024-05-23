import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:habib_app/core/common/widgets/hb_table.dart';
import 'package:habib_app/core/extensions/exception_extension.dart';
import 'package:habib_app/core/common/widgets/hb_app_bar.dart';
import 'package:habib_app/core/common/widgets/hb_button.dart';
import 'package:habib_app/core/common/widgets/hb_gap.dart';
import 'package:habib_app/core/common/widgets/hb_scaffold.dart';
import 'package:habib_app/core/common/widgets/sc_text_field.dart';
import 'package:habib_app/core/extensions/context_extension.dart';
import 'package:habib_app/core/res/hb_icons.dart';
import 'package:habib_app/core/res/theme/spacing/hb_spacing.dart';
import 'package:habib_app/core/services/routes.dart';
import 'package:habib_app/core/utils/constants/hb_ui_constants.dart';
import 'package:habib_app/core/utils/core_utils.dart';
import 'package:habib_app/core/utils/enums/toast_type.dart';
import 'package:habib_app/src/features/customers/domain/entities/customer_entity.dart';
import 'package:habib_app/src/features/customers/presentation/app/customers_page_notifier.dart';

class CustomersPage extends StatefulHookConsumerWidget {

  const CustomersPage({ super.key });

  @override
  ConsumerState<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends ConsumerState<CustomersPage> {

  final ScrollController _scrollController = ScrollController();

  late TextEditingController _searchController;

  void _onPageStateUpdate(CustomersPageState? _, CustomersPageState next) {
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
      ref.read(customersPageNotifierProvider.notifier).fetchNextPage(_searchText);
    }
  }

  HBTableStatus get _tableStatus {
    final CustomersPageState pageState = ref.read(customersPageNotifierProvider);
    if (pageState.status == CustomersPageStatus.success && pageState.customers.isNotEmpty) return HBTableStatus.data;
    if (pageState.status == CustomersPageStatus.failure || (pageState.status == CustomersPageStatus.success && pageState.customers.isEmpty)) return HBTableStatus.text;
    return HBTableStatus.loading;
  }

  String? get _tableText {
    final CustomersPageState pageState = ref.read(customersPageNotifierProvider);
    if (pageState.status == CustomersPageStatus.success && pageState.customers.isEmpty) return 'Keine Kunden gefunden.';
    if (pageState.status == CustomersPageStatus.failure) return 'Ein Fehler ist aufgetreten.';
    return null;
  }

  String get _searchText {
    return _searchController.text.trim();
  }

  Future<void> _onCustomerPressed(int customerId) async {
    await CustomerDetailsRoute(customerId: customerId).push(context);
  }

  Future<void> _onCreateCustomer() async {
    await const CreateCustomerRoute().push(context);
  }

  Future<void> _onSearchChanged() async {
    await ref.read(customersPageNotifierProvider.notifier).refresh(_searchText);
  }

  Future<void> _onRefresh() async {
    await ref.read(customersPageNotifierProvider.notifier).refresh(_searchText);
  }

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    CoreUtils.postFrameCall(() {
      ref.read(customersPageNotifierProvider.notifier).fetchNextPage(_searchText);
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

    final CustomersPageState pageState = ref.watch(customersPageNotifierProvider);

    _searchController = useTextEditingController();

    ref.listen<CustomersPageState>(
      customersPageNotifierProvider,
      _onPageStateUpdate
    );

    return HBScaffold(
      appBar: HBAppBar(
        context: context, 
        title: 'Kunden'
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
                  onChanged: (String _) => _onSearchChanged,
                  icon: HBIcons.magnifyingGlass,
                  hint: 'Name',
                  maxWidth: 500.0
                ),
                const HBGap.lg(),
                const Spacer(),
                HBButton.shrinkFill(
                  onPressed: _onCreateCustomer,
                  icon: HBIcons.plus,
                  title: 'Neue/r Kund*in'
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
              onPressed: (int index) => _onCustomerPressed(pageState.customers[index].id),
              status: _tableStatus,
              padding: EdgeInsets.only(
                left: HBSpacing.lg,
                right: context.rightPadding + HBSpacing.lg,
                bottom: context.bottomPadding + HBSpacing.lg,
                top: HBSpacing.xxl
              ),
              controller: _scrollController,
              tableWidth: context.width - HBUIConstants.navigationRailWidth - context.rightPadding - 4.0 * HBSpacing.lg,
              columnLength: 3,
              fractions: const [ 0.3, 0.4, 0.3 ],
              titles: const [ 'Name', 'Telefon / Mobil', 'Straße' ],
              items: List.generate(pageState.customers.length, (int index) {
                final CustomerEntity customer = pageState.customers[index];
                return [
                  HBTableText(text: '${ customer.title != null ? '${ customer.title } ' : '' }${ customer.firstName } ${ customer.lastName }'),
                  HBTableText(text: '${ customer.phone ?? '' }${ customer.phone != null && customer.mobile != null ? ' | ' : '' }${ customer.mobile ?? '' }'),
                  HBTableText(text: '${ customer.address.street }, ${ customer.address.postalCode } ${ customer.address.city }')
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
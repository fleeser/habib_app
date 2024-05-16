import 'package:flutter/material.dart';

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

class CustomersPage extends ConsumerStatefulWidget {

  const CustomersPage({ super.key });

  @override
  ConsumerState<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends ConsumerState<CustomersPage> {

  final ScrollController _scrollController = ScrollController();

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
      ref.read(customersPageNotifierProvider.notifier).fetchNextPage();
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

  Future<void> _onCustomerPressed(int customerId) async {
    await CustomerDetailsRoute(customerId: customerId).push(context);
  }

  Future<void> _onCreateCustomer() async {
    await const CreateCustomerRoute().push(context);
  }

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    CoreUtils.postFrameCall(() {
      ref.read(customersPageNotifierProvider.notifier).fetchNextPage();
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
                const HBTextField(
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
              columnLength: 2,
              fractions: const [ 0.1, 0.9 ],
              titles: const [ 'ID', 'Name' ],
              items: List.generate(pageState.customers.length, (int index) {
                final CustomerEntity customer = pageState.customers[index];
                return [
                  customer.id.toString(),
                  '${customer.firstName} ${customer.lastName}'
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
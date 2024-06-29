import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:habib_app/src/features/customers/domain/entities/customer_entity.dart';
import 'package:habib_app/src/features/customers/presentation/app/customers_page_notifier.dart';
import 'package:habib_app/src/features/borrows/presentation/pages/create_borrow_page.dart';
import 'package:habib_app/core/extensions/object_extension.dart';
import 'package:habib_app/core/common/widgets/hb_button.dart';
import 'package:habib_app/core/common/widgets/hb_gap.dart';
import 'package:habib_app/core/common/widgets/hb_selection_dialog.dart';
import 'package:habib_app/core/common/widgets/hb_table.dart';
import 'package:habib_app/core/common/widgets/hb_text_field.dart';
import 'package:habib_app/core/extensions/context_extension.dart';
import 'package:habib_app/core/res/hb_icons.dart';
import 'package:habib_app/core/res/theme/spacing/hb_spacing.dart';
import 'package:habib_app/core/utils/core_utils.dart';
import 'package:habib_app/core/utils/enums/toast_type.dart';

Future<CreateBorrowCustomer?> showCustomersSelectionDialog({
  required BuildContext context,
  required CreateBorrowCustomer? customer
}) async {
  return await showHBSelectionDialog<CreateBorrowCustomer>(
    context: context,
    title: 'Kund*innen wählen',
    content: CustomersSelectionDialog(customer: customer)
  );
}

class CustomersSelectionDialog extends StatefulHookConsumerWidget {

  final CreateBorrowCustomer? customer;

  const CustomersSelectionDialog({ 
    super.key,
    this.customer
  });

  @override
  ConsumerState<CustomersSelectionDialog> createState() => _CustomersSelectionDialogState();
}

class _CustomersSelectionDialogState extends ConsumerState<CustomersSelectionDialog> {

  late ValueNotifier<CreateBorrowCustomer?> _customerNotifier;

  final ScrollController _scrollController = ScrollController();

  late TextEditingController _searchController;

  void _onPageStateUpdate(CustomersPageState? _, CustomersPageState next) {
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
      ref.read(customersPageNotifierProvider.notifier).fetchNextPage(_searchText);
    }
  }

  HBTableStatus get _tableStatus {
    final CustomersPageState pageState = ref.read(customersPageNotifierProvider);
    if (pageState.hasCustomers) return HBTableStatus.data;
    if (pageState.hasError || !pageState.hasCustomers) return HBTableStatus.text;
    return HBTableStatus.loading;
  }

  String? get _tableText {
    final CustomersPageState pageState = ref.read(customersPageNotifierProvider);
    if (!pageState.isLoading && !pageState.hasError && !pageState.hasCustomers) return 'Keine Kund*innen gefunden.';
    if (pageState.hasError) return 'Ein Fehler ist aufgetreten.';
    return null;
  }

  String get _searchText {
    return _searchController.text.trim();
  }

  Future<void> _onSearchChanged(String _) async {
    await ref.read(customersPageNotifierProvider.notifier).refresh(_searchText);
  }

  Future<void> _onRefresh() async {
    await ref.read(customersPageNotifierProvider.notifier).refresh(_searchText);
  }

  void _onRowPressed(CustomerEntity selectedCustomer) async {
    final CreateBorrowCustomer newCustomer = CreateBorrowCustomer(
      id: selectedCustomer.id, 
      title: selectedCustomer.title,
      firstName: selectedCustomer.firstName,
      lastName: selectedCustomer.lastName
    );
    _customerNotifier.value = newCustomer;
  }

  void _cancel() {
    context.pop();
  }

  void _onChoose() {
    context.pop<CreateBorrowCustomer?>(_customerNotifier.value);
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

    _customerNotifier = useState<CreateBorrowCustomer?>(widget.customer);

    final CustomersPageState pageState = ref.watch(customersPageNotifierProvider);

    _searchController = useTextEditingController();

    ref.listen<CustomersPageState>(
      customersPageNotifierProvider,
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
            onPressed: (int index) => _onRowPressed(pageState.customers[index]),
            status: _tableStatus,
            padding: EdgeInsets.only(
              left: HBSpacing.lg,
              right: context.rightPadding + HBSpacing.lg,
              bottom: context.bottomPadding + HBSpacing.lg,
              top: HBSpacing.xxl
            ),
            controller: _scrollController,
            tableWidth: 800.0 - 4.0 * HBSpacing.lg,
            columnLength: 4,
            fractions: const [ 0.35, 0.3, 0.3, 0.05 ],
            titles: const [ 'Name', 'Telefon / Mobil', 'Straße', '' ],
            items: List.generate(pageState.customers.length, (int index) {
              final CustomerEntity customer = pageState.customers[index];
              final bool isSelected = _customerNotifier.value?.id == customer.id;
              return [
                HBTableText(text: '${ customer.title != null ? '${ customer.title } ' : '' }${ customer.firstName } ${ customer.lastName }'),
                HBTableText(text: '${ customer.phone ?? '' }${ customer.phone != null && customer.mobile != null ? ' | ' : '' }${ customer.mobile ?? '' }'),
                HBTableText(text: '${ customer.address.street }, ${ customer.address.postalCode } ${ customer.address.city }'),
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
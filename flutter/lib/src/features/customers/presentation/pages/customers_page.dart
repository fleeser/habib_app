import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_conditional/flutter_conditional.dart';

import 'package:habib_app/core/extensions/exception_extension.dart';
import 'package:habib_app/core/common/widgets/hb_app_bar.dart';
import 'package:habib_app/core/common/widgets/hb_button.dart';
import 'package:habib_app/core/common/widgets/hb_gap.dart';
import 'package:habib_app/core/common/widgets/hb_scaffold.dart';
import 'package:habib_app/core/common/widgets/sc_text_field.dart';
import 'package:habib_app/core/extensions/context_extension.dart';
import 'package:habib_app/core/res/hb_icons.dart';
import 'package:habib_app/core/res/theme/colors/hb_colors.dart';
import 'package:habib_app/core/res/theme/spacing/hb_spacing.dart';
import 'package:habib_app/core/res/theme/typography/hb_typography.dart';
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

  Future<void> _onCustomerPressed(int customerId) async {
    await CustomerDetailsRoute(customerId: customerId).push(context);
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

    final double tableWidth = context.width - HBUIConstants.navigationRailWidth - context.rightPadding - 4.0 * HBSpacing.lg;

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
              top: HBSpacing.lg,
              bottom: HBSpacing.lg
            ),
            child: const Row(
              children: [
                HBTextField(
                  icon: HBIcons.magnifyingGlass,
                  hint: 'Name',
                  maxWidth: 500.0
                ),
                HBGap.lg(),
                Spacer(),
                HBButton.shrinkFill(
                  icon: HBIcons.plus,
                  title: 'Neue/r Kund*in'
                )
              ]
            )
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 2.0 * HBSpacing.lg,
              right: context.rightPadding + 2.0 * HBSpacing.lg,
              top: HBSpacing.xxl,
              bottom: HBSpacing.lg
            ),
            child: Row(
              children: [
                SizedBox(
                  width: tableWidth * 0.1,
                  child: Text(
                    'ID',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: HBTypography.base.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: HBColors.gray900
                    )
                  )
                ),
                SizedBox(
                  width: tableWidth * 0.9,
                  child: Text(
                    'Name',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: HBTypography.base.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: HBColors.gray900
                    )
                  )
                )
              ]
            )
          ),
          Expanded(
            child: Conditional.multiCase(
              cases: <Case>[
                Case(
                  condition: pageState.status == CustomersPageStatus.success && pageState.customers.isNotEmpty,
                  widget: ListView.builder(
                    padding: EdgeInsets.only(
                      left: HBSpacing.lg,
                      right: context.rightPadding + HBSpacing.lg,
                      bottom: context.bottomPadding + HBSpacing.lg
                    ),
                    itemCount: pageState.customers.length,
                    itemBuilder: (BuildContext context, int index) {

                      final CustomerEntity customer = pageState.customers[index];

                      return SizedBox(
                        height: 50.0,
                        child: RawMaterialButton(
                          onPressed: () => _onCustomerPressed(customer.id),
                          padding: const EdgeInsets.symmetric(horizontal: HBSpacing.lg),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(HBUIConstants.defaultBorderRadius)),
                          child: Row(
                            children: [
                              SizedBox(
                                width: tableWidth * 0.1,
                                child: Text(
                                  customer.id.toString(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: HBTypography.base.copyWith(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                    color: HBColors.gray900
                                  )
                                )
                              ),
                              SizedBox(
                                width: tableWidth * 0.9,
                                child: Text(
                                  customer.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: HBTypography.base.copyWith(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                    color: HBColors.gray900
                                  )
                                )
                              )
                            ]
                          )
                        )
                      );
                    }
                  )
                ),
                Case(
                  condition: pageState.status == CustomersPageStatus.success && pageState.customers.isEmpty,
                  widget: Center(
                    child: Text(
                      'Keine Kund*innen gefunden.',
                      textAlign: TextAlign.center,
                      style: HBTypography.base.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: HBColors.gray900
                      )
                    )
                  )
                ),
                Case(
                  condition: pageState.status == CustomersPageStatus.failure,
                  widget: Center(
                    child: Text(
                      'Ein Fehler ist aufgetreten.',
                      textAlign: TextAlign.center,
                      style: HBTypography.base.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: HBColors.gray900
                      )
                    )
                  )
                )
              ]
            )
          )
        ]
      )
    );
  }
}
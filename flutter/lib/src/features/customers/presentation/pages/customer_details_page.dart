import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import 'package:habib_app/src/features/customers/domain/entities/customer_details_address_entity.dart';
import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/src/features/customers/domain/usecases/customer_update_customer_usecase.dart';
import 'package:habib_app/core/utils/validator.dart';
import 'package:habib_app/src/features/customers/domain/entities/customer_details_entity.dart';
import 'package:habib_app/core/res/theme/colors/hb_colors.dart';
import 'package:habib_app/core/res/theme/typography/hb_typography.dart';
import 'package:habib_app/core/common/widgets/hb_gap.dart';
import 'package:habib_app/core/common/widgets/hb_text_field.dart';
import 'package:habib_app/core/extensions/context_extension.dart';
import 'package:habib_app/core/res/theme/spacing/hb_spacing.dart';
import 'package:habib_app/core/common/models/error_details.dart';
import 'package:habib_app/core/common/widgets/hb_message_box.dart';
import 'package:habib_app/core/utils/result.dart';
import 'package:habib_app/src/features/customers/domain/usecases/customer_delete_customer_usecase.dart';
import 'package:habib_app/src/features/customers/presentation/widgets/customer_borrows_table.dart';
import 'package:habib_app/core/extensions/object_extension.dart';
import 'package:habib_app/src/features/customers/presentation/app/customer_details_page_notifier.dart';
import 'package:habib_app/core/utils/enums/toast_type.dart';
import 'package:habib_app/core/common/widgets/hb_app_bar.dart';
import 'package:habib_app/core/common/widgets/hb_scaffold.dart';
import 'package:habib_app/core/res/hb_icons.dart';
import 'package:habib_app/core/utils/core_utils.dart';

class CustomerDetailsPageParams {

  final int customerId;

  const CustomerDetailsPageParams({
    required this.customerId
  });
}

class CustomerDetailsPage extends StatefulHookConsumerWidget {

  final CustomerDetailsPageParams params;
  
  const CustomerDetailsPage({ 
    super.key,
    required this.params
  });

  @override
  ConsumerState<CustomerDetailsPage> createState() => _CustomerDetailsPageState();
}

class _CustomerDetailsPageState extends ConsumerState<CustomerDetailsPage> {

  late TextEditingController _titleController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _occupationController;
  late TextEditingController _phoneController;
  late TextEditingController _mobileController;
  late TextEditingController _streetController;
  late TextEditingController _postalCodeController;
  late TextEditingController _cityController;

  void _onDetailsStateUpdate(CustomerDetailsPageState? _, CustomerDetailsPageState next) {
    if (next.hasError) {
      CoreUtils.showToast(
        context, 
        type: ToastType.error, 
        title: next.error!.errorTitle, 
        description: next.error!.errorDescription, 
      );
    }
  }

  Future<void> _onRefresh() async {
    ref.read(customerDetailsPageNotifierProvider(widget.params.customerId).notifier).fetch();
  }

  Future<void> _onSave() async {
    final CustomerDetailsPageState pageState = ref.watch(customerDetailsPageNotifierProvider(widget.params.customerId));
    final CustomerDetailsEntity customer = pageState.customer!;

    final String title = _titleController.text.trim();
    final String firstName = _firstNameController.text.trim();
    final String lastName = _lastNameController.text.trim();
    final String occupation = _occupationController.text.trim();
    final String phone = _phoneController.text.trim();
    final String mobile = _mobileController.text.trim();
    final String addressStreet = _streetController.text.trim();
    final String addressPostalCode = _postalCodeController.text.trim();
    final String addressCity = _cityController.text.trim();

    try {
      Validator.validateCustomerUpdate(
        title: title,
        firstName: firstName,
        lastName: lastName,
        occupation: occupation,
        phone: phone,
        mobile: mobile,
        addressStreet: addressStreet,
        addressPostalCode: addressPostalCode,
        addressCity: addressCity
      );
    } catch (e) {
      CoreUtils.showToast(
        context, 
        type: ToastType.error, 
        title: e.errorTitle, 
        description: e.errorDescription, 
      );
      return;
    }

    final bool replaceTitle = title != (customer.title ?? '');
    final bool replaceFirstName = firstName != customer.firstName;
    final bool replaceLastName = lastName != customer.lastName;
    final bool replaceOccupation = occupation != (customer.occupation ?? '');
    final bool replacePhone = phone != (customer.phone ?? '');
    final bool replaceMobile = mobile != (customer.mobile ?? '');
    final bool replaceAddressStreet = addressStreet != customer.address.street;
    final bool replaceAddressPostalCode = addressPostalCode != customer.address.postalCode;
    final bool replaceAddressCity = addressCity != customer.address.city;

    Json customerJson = <String, dynamic>{
      if (replaceTitle) 'title' : "'$title'",
      if (replaceFirstName) 'first_name' : "'$firstName'",
      if (replaceLastName) 'last_name' : "'$lastName'",
      if (replaceOccupation) 'occupation' : "'$occupation'",
      if (replacePhone) 'phone' : "'$phone'",
      if (replaceMobile) 'mobile' : "'$mobile'"
    };

    Json addressJson = <String, dynamic>{
      if (replaceAddressStreet) 'street' : "'$addressStreet'",
      if (replaceAddressPostalCode) 'postal_code' : "'$addressPostalCode'",
      if (replaceAddressCity) 'city' : "'$addressCity'"
    };

    if (customerJson.isEmpty && addressJson.isEmpty) return;

    final CustomerUpdateCustomerUsecase customerUpdateCustomerUsecase = ref.read(customerUpdateCustomerUsecaseProvider);
    final CustomerUpdateCustomerUsecaseParams customerUpdateCustomerUsecaseParams = CustomerUpdateCustomerUsecaseParams(
      customerId: customer.id,
      customerJson: customerJson,
      addressId: customer.address.id,
      addressJson: addressJson
    );
    final Result<void> customerUpdateCustomerUsecaseResult = await customerUpdateCustomerUsecase.call(customerUpdateCustomerUsecaseParams);

    customerUpdateCustomerUsecaseResult.fold<void>(
      onSuccess: (void _) {
        ref.read(customerDetailsPageNotifierProvider(widget.params.customerId).notifier).replace(
          CustomerDetailsEntity(
            id: customer.id, 
            firstName: replaceFirstName ? firstName : customer.firstName, 
            lastName: replaceLastName ? lastName : customer.lastName, 
            occupation: replaceOccupation ? occupation : customer.occupation,
            phone: replacePhone ? phone : customer.phone,
            mobile: replaceMobile ? mobile : customer.mobile,
            address: CustomerDetailsAddressEntity(
              id: customer.address.id,
              street: replaceAddressStreet ? addressStreet : customer.address.street,
              postalCode: replaceAddressPostalCode ? addressPostalCode : customer.address.postalCode,
              city: replaceAddressCity ? addressCity : customer.address.city
            )
          )
        );

        CoreUtils.showToast(
          context, 
          type: ToastType.success, 
          title: 'Erfolgreich aktualisiert.',
          description: 'Der Kunde wurde erfolgreich aktualisiert.' 
        );
      },
      onFailure: (Object error, StackTrace stackTrace) {
        final ErrorDetails errorDetails = ErrorDetails(
          error: error, 
          stackTrace: stackTrace
        );
        CoreUtils.showToast(
          context, 
          type: ToastType.error, 
          title: errorDetails.errorTitle, 
          description: errorDetails.errorDescription, 
        );
      }
    );
  }

  Future<void> _onDelete() async {
    final bool? success = await showHBMessageBox(
      context, 
      'Diesen Kunden wirklich löschen?', 
      'Wenn Sie diesen Kunden löschen, werden alle damit verbundenen Daten ebenfalls gelöscht. Dieser Vorgang kann nicht rückgängig gemacht werden.',
      'Löschen',
      onPressed: () async {
        final CustomerDeleteCustomerUsecase customerDeleteCustomerUsecase = ref.read(customerDeleteCustomerUsecaseProvider);
        final CustomerDeleteCustomerUsecaseParams customerDeleteCustomerUsecaseParams = CustomerDeleteCustomerUsecaseParams(customerId: widget.params.customerId);
        final Result<void> customerDeleteCustomerUsecaseResult = await customerDeleteCustomerUsecase.call(customerDeleteCustomerUsecaseParams);

        return customerDeleteCustomerUsecaseResult.fold<bool>(
          onSuccess: (void _) => true,
          onFailure: (Object error, StackTrace stackTrace) {
            final ErrorDetails errorDetails = ErrorDetails(
              error: error, 
              stackTrace: stackTrace
            );
            CoreUtils.showToast(
              context, 
              type: ToastType.error, 
              title: errorDetails.errorTitle, 
              description: errorDetails.errorDescription, 
            );
            return false;
          }
        );
      }
    );

    if (mounted && context.canPop() && (success ?? false)) context.pop(true);
  }

  @override
  void initState() {
    super.initState();

    CoreUtils.postFrameCall(() {
      ref.read(customerDetailsPageNotifierProvider(widget.params.customerId).notifier).fetch();
    });
  }

  @override
  Widget build(BuildContext context) {

    final CustomerDetailsPageState pageState = ref.watch(customerDetailsPageNotifierProvider(widget.params.customerId));

    if (pageState.hasCustomer) {
      _titleController = useTextEditingController(text: pageState.customer!.title);
      _firstNameController = useTextEditingController(text: pageState.customer!.firstName);
      _lastNameController = useTextEditingController(text: pageState.customer!.lastName);
      _occupationController = useTextEditingController(text: pageState.customer!.occupation);
      _phoneController = useTextEditingController(text: pageState.customer!.phone);
      _mobileController = useTextEditingController(text: pageState.customer!.mobile);
      _streetController = useTextEditingController(text: pageState.customer!.address.street);
      _postalCodeController = useTextEditingController(text: pageState.customer!.address.postalCode);
      _cityController = useTextEditingController(text: pageState.customer!.address.city);
    }

    ref.listen<CustomerDetailsPageState>(
      customerDetailsPageNotifierProvider(widget.params.customerId), 
      _onDetailsStateUpdate
    );
    
    return HBScaffold(
      appBar: HBAppBar(
        context: context,
        title: 'Details',
        backButton: const HBAppBarBackButton(),
        actionButtons: [
          HBAppBarButton(
            onPressed: _onRefresh,
            icon: HBIcons.arrowPath,
            isEnabled: !pageState.isLoading
          ),
          HBAppBarButton(
            onPressed: _onSave,
            icon: HBIcons.cloudArrowUp,
            isEnabled: pageState.hasCustomer,
          ),
          HBAppBarButton(
            onPressed: _onDelete,
            icon: HBIcons.trash,
            isEnabled: pageState.hasCustomer
          )
        ]
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: pageState.hasCustomer
              ? SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: HBSpacing.lg,
                  right: context.rightPadding + HBSpacing.lg,
                  top: HBSpacing.lg
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Personendetails',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: HBTypography.base.copyWith(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: HBColors.gray900
                      )
                    ),
                    const HBGap.xl(),
                    Row(
                      children: [
                        Expanded(
                          child: HBTextField(
                            title: 'Titel',
                            controller: _titleController,
                            icon: HBIcons.home
                          )
                        ),
                        const HBGap.xl(),
                        Expanded(
                          child: HBTextField(
                            title: 'Vorname',
                            controller: _firstNameController,
                            icon: HBIcons.hashtag
                          )
                        ),
                        const HBGap.xl(),
                        Expanded(
                          child: HBTextField(
                            title: 'Nachname',
                            controller: _lastNameController,
                            icon: HBIcons.hashtag
                          )
                        )
                      ]
                    ),
                    const HBGap.xl(),
                    Row(
                      children: [
                        Expanded(
                          child: HBTextField(
                            title: 'Beruf',
                            controller: _occupationController,
                            icon: HBIcons.home
                          )
                        ),
                        const HBGap.xl(),
                        const Spacer(),
                        const HBGap.xl(),
                        const Spacer()
                      ]
                    ),
                    const HBGap.xxl(),
                    Text(
                      'Kontaktinformationen',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: HBTypography.base.copyWith(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: HBColors.gray900
                      )
                    ),
                    const HBGap.xl(),
                    Row(
                      children: [
                        Expanded(
                          child: HBTextField(
                            title: 'Telefon',
                            controller: _phoneController,
                            icon: HBIcons.home,
                            inputType: TextInputType.phone
                          )
                        ),
                        const HBGap.xl(),
                        Expanded(
                          child: HBTextField(
                            title: 'Mobil',
                            controller: _mobileController,
                            icon: HBIcons.hashtag,
                            inputType: TextInputType.phone
                          )
                        ),
                        const HBGap.xl(),
                        const Spacer()
                      ]
                    ),
                    const HBGap.xxl(),
                    Text(
                      'Adresse',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: HBTypography.base.copyWith(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: HBColors.gray900
                      )
                    ),
                    const HBGap.xl(),
                    Row(
                      children: [
                        Expanded(
                          child: HBTextField(
                            title: 'Straße & Hausnummer',
                            controller: _streetController,
                            icon: HBIcons.home,
                            inputType: TextInputType.streetAddress
                          )
                        ),
                        const HBGap.xl(),
                        Expanded(
                          child: HBTextField(
                            title: 'Postleitzahl',
                            controller: _postalCodeController,
                            icon: HBIcons.hashtag,
                            inputType: TextInputType.number
                          )
                        ),
                        const HBGap.xl(),
                        Expanded(
                          child: HBTextField(
                            title: 'Stadt',
                            controller: _cityController,
                            icon: HBIcons.hashtag
                          )
                        )
                      ]
                    )
                  ]
                )
              )
              : pageState.hasError
                ? Center(
                  child: Text(
                    pageState.error!.errorDescription,
                    textAlign: TextAlign.center,
                    style: HBTypography.base.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: HBColors.gray900
                    ),
                  )
                )
                : const SizedBox.shrink()
          ),
          const Divider(),
          Expanded(
            flex: 2,
            child: CustomerBorrowsTable(customerId: widget.params.customerId)
          )
        ]
      )
    );
  }
}
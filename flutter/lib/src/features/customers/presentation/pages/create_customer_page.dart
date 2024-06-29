import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:habib_app/core/common/models/error_details.dart';
import 'package:habib_app/core/common/widgets/hb_dialog.dart';
import 'package:habib_app/core/common/widgets/hb_gap.dart';
import 'package:habib_app/core/common/widgets/hb_text_field.dart';
import 'package:habib_app/core/extensions/object_extension.dart';
import 'package:habib_app/core/res/hb_icons.dart';
import 'package:habib_app/core/services/routes.dart';
import 'package:habib_app/core/utils/core_utils.dart';
import 'package:habib_app/core/utils/enums/toast_type.dart';
import 'package:habib_app/core/utils/result.dart';
import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/core/utils/validator.dart';
import 'package:habib_app/src/features/customers/domain/usecases/customer_create_customer_usecase.dart';

class CreateCustomerPage extends StatefulHookConsumerWidget {
  
  const CreateCustomerPage({ super.key });

  @override
  ConsumerState<CreateCustomerPage> createState() => _CreateCustomerPageState();
}

class _CreateCustomerPageState extends ConsumerState<CreateCustomerPage> {

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _titleController;
  late TextEditingController _occupationController;
  late TextEditingController _phoneController;
  late TextEditingController _mobileController;
  late TextEditingController _postalCodeController;
  late TextEditingController _cityController;
  late TextEditingController _streetController;

  Future<void> _handleCreate() async {
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
      Validator.validateCustomerCreate(
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

    Json addressJson = <String, dynamic>{
      'street' : "'$addressStreet'",
      'postal_code' : "'$addressPostalCode'",
      'city' : "'$addressCity'"
    };

    Json customerJson = <String, dynamic>{
      if (title.isNotEmpty) 'title' : "'$title'",
      'first_name' : "'$firstName'",
      'last_name' : "'$lastName'",
      if (occupation.isNotEmpty) 'occupation' : "'$occupation'",
      if (phone.isNotEmpty) 'phone' : "'$phone'",
      if (mobile.isNotEmpty) 'mobile' : "'$mobile'"
    };

    final CustomerCreateCustomerUsecase customerCreateCustomerUsecase = ref.read(customerCreateCustomerUsecaseProvider);
    final CustomerCreateCustomerUsecaseParams customerCreateCustomerUsecaseParams = CustomerCreateCustomerUsecaseParams(
      addressJson: addressJson,
      customerJson: customerJson
    );
    final Result<int> customerCreateCustomerUsecaseResult = await customerCreateCustomerUsecase.call(customerCreateCustomerUsecaseParams);

    customerCreateCustomerUsecaseResult.fold<void>(
      onSuccess: (int customerId) async {
        CoreUtils.showToast(
          context, 
          type: ToastType.success, 
          title: 'Erfolgreich angelegt.',
          description: 'Der Kunde wurde erfolgreich angelegt.' 
        );

        if (!mounted) return;

        context.pop();

        await CustomerDetailsRoute(customerId: customerId).push(context);
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
  
  @override
  Widget build(BuildContext context) {

    _firstNameController = useTextEditingController();
    _lastNameController = useTextEditingController();
    _titleController = useTextEditingController();
    _occupationController = useTextEditingController();
    _phoneController = useTextEditingController();
    _mobileController = useTextEditingController();
    _postalCodeController = useTextEditingController();
    _cityController = useTextEditingController();
    _streetController = useTextEditingController();

    return HBDialog<int>(
      title: 'Neuer Kunde',
      actionButton: HBDialogActionButton(
        onPressed: _handleCreate,
        title: 'Erstellen'
      ),
      children: [
        const HBDialogSection(
          title: 'Personendatails',
          isFirstSection: true
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: HBTextField(
                controller: _titleController,
                icon: HBIcons.academicCap,
                title: 'Titel'
              )
            ),
            const HBGap.lg(),
            Expanded(
              child: HBTextField(
                controller: _firstNameController,
                icon: HBIcons.user,
                title: 'Vorname'
              )
            )
          ]
        ),
        const HBGap.lg(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: HBTextField(
                controller: _lastNameController,
                icon: HBIcons.user,
                title: 'Nachname'
              )
            ),
            const HBGap.lg(),
            Expanded(
              child: HBTextField(
                controller: _occupationController,
                icon: HBIcons.beaker,
                title: 'Beruf'
              )
            )
          ]
        ),
        const HBDialogSection(title: 'Kontaktinformationen'),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: HBTextField(
                controller: _phoneController,
                icon: HBIcons.phone,
                title: 'Telefon'
              )
            ),
            const HBGap.lg(),
            Expanded(
              child: HBTextField(
                controller: _mobileController,
                icon: HBIcons.phone,
                title: 'Mobil'
              )
            )
          ]
        ),
        const HBDialogSection(title: 'Adresse'),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: HBTextField(
                controller: _streetController,
                icon: HBIcons.beaker,
                title: 'Straße & Hausnummer'
              )
            ),
            const HBGap.lg(),
            const Spacer()
          ]
        ),
        const HBGap.lg(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: HBTextField(
                controller: _postalCodeController,
                icon: HBIcons.user,
                title: 'Postleitzahl'
              )
            ),
            const HBGap.lg(),
            Expanded(
              child: HBTextField(
                controller: _cityController,
                icon: HBIcons.user,
                title: 'Stadt'
              )
            )
          ]
        )
      ]
    );
  }
}
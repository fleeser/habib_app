import 'package:flutter/material.dart';

import 'package:flutter_conditional/flutter_conditional.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:habib_app/core/common/widgets/hb_chip.dart';
import 'package:habib_app/src/features/borrows/presentation/widgets/borrow_status_selection_dialog.dart';
import 'package:habib_app/src/features/books/presentation/widgets/books_selection_dialog.dart';
import 'package:habib_app/src/features/customers/presentation/widgets/customers_selection_dialog.dart';
import 'package:habib_app/core/common/models/error_details.dart';
import 'package:habib_app/core/extensions/object_extension.dart';
import 'package:habib_app/core/services/routes.dart';
import 'package:habib_app/core/utils/core_utils.dart';
import 'package:habib_app/core/utils/enums/toast_type.dart';
import 'package:habib_app/core/utils/result.dart';
import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/core/utils/validator.dart';
import 'package:habib_app/src/features/borrows/domain/usecases/borrow_create_borrow_usecase.dart';
import 'package:habib_app/core/utils/enums/borrow_status.dart';
import 'package:habib_app/core/common/widgets/hb_light_button.dart';
import 'package:habib_app/core/res/theme/colors/hb_colors.dart';
import 'package:habib_app/core/res/theme/typography/hb_typography.dart';
import 'package:habib_app/core/common/widgets/hb_date_button.dart';
import 'package:habib_app/core/common/widgets/hb_dialog.dart';
import 'package:habib_app/core/common/widgets/hb_gap.dart';

class CreateBorrowPageParams {

  final CreateBorrowBook? book;
  final CreateBorrowCustomer? customer;

  const CreateBorrowPageParams({
    this.book,
    this.customer
  });
}

class CreateBorrowBook {

  final int id;
  final String title;
  final int? edition;

  const CreateBorrowBook({
    required this.id,
    required this.title,
    this.edition
  });

  String toOneLine() {
    return '$title${ edition != null ? ' ($edition. Auflage)' : '' }';
  }
}

class CreateBorrowCustomer {

  final int id;
  final String? title;
  final String firstName;
  final String lastName;

  const CreateBorrowCustomer({
    required this.id,
    this.title,
    required this.firstName,
    required this.lastName
  });

  String toOneLine() {
    return '${ title != null ? '$title ' : '' }$firstName $lastName';
  }
}

class CreateBorrowPage extends StatefulHookConsumerWidget {

  final CreateBorrowPageParams? params;
  
  const CreateBorrowPage({ 
    super.key,
    this.params
  });

  @override
  ConsumerState<CreateBorrowPage> createState() => _CreateBorrowPageState();
}

class _CreateBorrowPageState extends ConsumerState<CreateBorrowPage> {

  late ValueNotifier<DateTime> _endDateNotifier;
  late ValueNotifier<BorrowStatus> _statusNotifier;
  late ValueNotifier<CreateBorrowBook?> _bookNotifier;
  late ValueNotifier<CreateBorrowCustomer?> _customerNotifier;

  Future<void> _handleCreate() async {
    final DateTime endDate = _endDateNotifier.value;
    final BorrowStatus status = _statusNotifier.value;
    final int? bookId = _bookNotifier.value?.id;
    final int? customerId = _customerNotifier.value?.id;

    try {
      Validator.validateBorrowCreate(
        endDate: endDate,
        status: status
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

    Json borrowJson = <String, dynamic>{
      'end_date' : "'${ endDate.toIso8601String() }'",
      'status' : "'${ status.databaseValue }'",
      'book_id' : bookId,
      'customer_id' : customerId
    };

    final BorrowCreateBorrowUsecase borrowCreateBorrowUsecase = ref.read(borrowCreateBorrowUsecaseProvider);
    final BorrowCreateBorrowUsecaseParams borrowCreateBorrowUsecaseParams = BorrowCreateBorrowUsecaseParams(
      borrowJson: borrowJson
    );
    final Result<int> borrowCreateBorrowUsecaseResult = await borrowCreateBorrowUsecase.call(borrowCreateBorrowUsecaseParams);

    borrowCreateBorrowUsecaseResult.fold<void>(
      onSuccess: (int borrowId) async {
        CoreUtils.showToast(
          context, 
          type: ToastType.success, 
          title: 'Erfolgreich angelegt.',
          description: 'Die Ausleihe wurde erfolgreich angelegt.' 
        );

        if (!mounted) return;

        context.pop();

        await BorrowDetailsRoute(borrowId: borrowId).push(context);
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

  void _handleEndDateChanged(DateTime newDate) {
    _endDateNotifier.value = newDate;
  }

  Future<void> _handleEditStatus() async {
    BorrowStatus? newStatus = await showBorrowStatusSelectionDialog(context: context);
    if (newStatus != null) _statusNotifier.value = newStatus;
  }

  Future<void> _handleEditBook() async {
    CreateBorrowBook? newBook = await showBooksSelectionDialog(
      context: context, 
      book: _bookNotifier.value
    );

    if (newBook != null) _bookNotifier.value = newBook;
  }

  Future<void> _handleEditCustomer() async {
    CreateBorrowCustomer? newCustomer = await showCustomersSelectionDialog(
      context: context, 
      customer: _customerNotifier.value
    );

    if (newCustomer != null) _customerNotifier.value = newCustomer;
  }
  
  @override
  Widget build(BuildContext context) {

    _endDateNotifier = useState<DateTime>(DateTime.now().add(const Duration(days: 14)));
    _statusNotifier = useState<BorrowStatus>(BorrowStatus.borrowed);
    _bookNotifier = useState<CreateBorrowBook?>(widget.params?.book);
    _customerNotifier = useState<CreateBorrowCustomer?>(widget.params?.customer);

    return HBDialog<int>(
      title: 'Neue Ausleihe',
      actionButton: HBDialogActionButton(
        onPressed: _handleCreate,
        title: 'Erstellen'
      ),
      children: [
        const HBDialogSection(
          title: 'Allgemeine Details',
          isFirstSection: true
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: HBDateButton(
                onChanged: _handleEndDateChanged,
                title: 'Rückgabedatum',
                dateTime: _endDateNotifier.value
              )
            ),
            const HBGap.lg(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Status',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: HBTypography.base.copyWith(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: HBColors.gray900
                          )
                        )
                      ),
                      const HBGap.md(),
                      HBLightButton(
                        onPressed: _handleEditStatus,
                        textAlign: TextAlign.end,
                        title: 'Bearbeiten'
                      )
                    ]
                  ),
                  const HBGap.md(),
                  HBChip(
                    text: _statusNotifier.value.title, 
                    color: _statusNotifier.value.color
                  )
                ]
              )
            )
          ]
        ),
        const HBDialogSection(title: 'Leihinformationen'),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Buch',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: HBTypography.base.copyWith(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: HBColors.gray900
                          )
                        )
                      ),
                      const HBGap.md(),
                      HBLightButton(
                        onPressed: _handleEditBook,
                        textAlign: TextAlign.end,
                        title: 'Bearbeiten'
                      )
                    ]
                  ),
                  const HBGap.md(),
                  Conditional.single(
                    condition: _bookNotifier.value != null,
                    widget: HBChip(
                      text: '${ _bookNotifier.value?.title }${ _bookNotifier.value?.edition != null ? ' (${ _bookNotifier.value?.edition }. Auflage)' : '' }',
                      color: HBColors.gray900
                    ),
                    fallback: Text(
                      'Kein Buch gewählt',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: HBTypography.base.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600
                      )
                    )
                  )
                ]
              )
            ),
            const HBGap.lg(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Kunde',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: HBTypography.base.copyWith(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: HBColors.gray900
                          )
                        )
                      ),
                      const HBGap.md(),
                      HBLightButton(
                        onPressed: _handleEditCustomer,
                        textAlign: TextAlign.end,
                        title: 'Bearbeiten'
                      )
                    ]
                  ),
                  const HBGap.md(),
                  Conditional.single(
                    condition: _customerNotifier.value != null,
                    widget: HBChip(
                      text: '${ _customerNotifier.value?.title != null ? '${ _customerNotifier.value?.title } ' : '' }${ _customerNotifier.value?.firstName } ${ _customerNotifier.value?.lastName }',
                      color: HBColors.gray900
                    ),
                    fallback: Text(
                      'Kein Kunde gewählt',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: HBTypography.base.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600
                      )
                    )
                  )
                ]
              )
            )
          ]
        )
      ]
    );
  }
}
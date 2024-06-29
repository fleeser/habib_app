import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import 'package:habib_app/src/features/books/presentation/widgets/books_selection_dialog.dart';
import 'package:habib_app/src/features/borrows/presentation/pages/create_borrow_page.dart';
import 'package:habib_app/src/features/borrows/presentation/widgets/borrow_status_selection_dialog.dart';
import 'package:habib_app/src/features/customers/presentation/widgets/customers_selection_dialog.dart';
import 'package:habib_app/core/common/widgets/hb_chip.dart';
import 'package:habib_app/core/common/widgets/hb_date_button.dart';
import 'package:habib_app/core/common/widgets/hb_light_button.dart';
import 'package:habib_app/core/common/widgets/hb_gap.dart';
import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/core/utils/validator.dart';
import 'package:habib_app/src/features/borrows/domain/entities/borrow_details_entity.dart';
import 'package:habib_app/src/features/borrows/domain/usecases/borrow_update_borrow_usecase.dart';
import 'package:habib_app/core/utils/enums/borrow_status.dart';
import 'package:habib_app/src/features/borrows/domain/entities/borrow_details_book_entity.dart';
import 'package:habib_app/src/features/borrows/domain/entities/borrow_details_customer_entity.dart';
import 'package:habib_app/src/features/borrows/domain/usecases/borrow_delete_borrow_usecase.dart';
import 'package:habib_app/src/features/borrows/presentation/app/borrow_details_page_notifier.dart';
import 'package:habib_app/core/res/theme/colors/hb_colors.dart';
import 'package:habib_app/core/res/theme/typography/hb_typography.dart';
import 'package:habib_app/core/extensions/context_extension.dart';
import 'package:habib_app/core/res/theme/spacing/hb_spacing.dart';
import 'package:habib_app/core/common/models/error_details.dart';
import 'package:habib_app/core/common/widgets/hb_message_box.dart';
import 'package:habib_app/core/utils/result.dart';
import 'package:habib_app/core/extensions/object_extension.dart';
import 'package:habib_app/core/utils/enums/toast_type.dart';
import 'package:habib_app/core/common/widgets/hb_app_bar.dart';
import 'package:habib_app/core/common/widgets/hb_scaffold.dart';
import 'package:habib_app/core/res/hb_icons.dart';
import 'package:habib_app/core/utils/core_utils.dart';

class BorrowDetailsPageParams {

  final int borrowId;

  const BorrowDetailsPageParams({
    required this.borrowId
  });
}

class BorrowDetailsPage extends StatefulHookConsumerWidget {

  final BorrowDetailsPageParams params;
  
  const BorrowDetailsPage({ 
    super.key,
    required this.params
  });

  @override
  ConsumerState<BorrowDetailsPage> createState() => _BorrowDetailsPageState();
}

class _BorrowDetailsPageState extends ConsumerState<BorrowDetailsPage> {

  late ValueNotifier<DateTime> _endDateNotifier;
  late ValueNotifier<BorrowStatus> _statusNotifier;
  late ValueNotifier<BorrowDetailsBookEntity> _bookNotifier;
  late ValueNotifier<BorrowDetailsCustomerEntity> _customerNotifier;

  void _onDetailsStateUpdate(BorrowDetailsPageState? _, BorrowDetailsPageState next) {
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
    ref.read(borrowDetailsPageNotifierProvider(widget.params.borrowId).notifier).fetch();
  }

  Future<void> _onSave() async {
    final BorrowDetailsPageState pageState = ref.watch(borrowDetailsPageNotifierProvider(widget.params.borrowId));
    final BorrowDetailsEntity borrow = pageState.borrow!;

    final DateTime endDate = _endDateNotifier.value;
    final BorrowStatus status = _statusNotifier.value;
    final BorrowDetailsBookEntity book = _bookNotifier.value;
    final BorrowDetailsCustomerEntity customer = _customerNotifier.value;

    try {
      Validator.validateBorrowUpdate(
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

    final bool replaceEndDate = endDate != borrow.endDate;
    final bool replaceStatus = status != borrow.status;
    final bool replaceBook = book.id != borrow.book.id;
    final bool replaceCustomer = customer.id != borrow.customer.id;

    Json borrowJson = <String, dynamic>{
      if (replaceEndDate) 'end_date' : "'${ endDate.toIso8601String() }'",
      if (replaceStatus) 'status' : "'${ status.databaseValue }'",
      if (replaceBook) 'book_id' : book.id,
      if (replaceCustomer) 'customer_id' : customer.id,
    };

    if (borrowJson.isEmpty) return;

    final BorrowUpdateBorrowUsecase borrowUpdateBorrowUsecase = ref.read(borrowUpdateBorrowUsecaseProvider);
    final BorrowUpdateBorrowUsecaseParams borrowUpdateBorrowUsecaseParams = BorrowUpdateBorrowUsecaseParams(
      borrowId: borrow.id,
      borrowJson: borrowJson
    );
    final Result<void> borrowUpdateBorrowUsecaseResult = await borrowUpdateBorrowUsecase.call(borrowUpdateBorrowUsecaseParams);

    borrowUpdateBorrowUsecaseResult.fold<void>(
      onSuccess: (void _) {
        ref.read(borrowDetailsPageNotifierProvider(widget.params.borrowId).notifier).replace(
          BorrowDetailsEntity(
            id: customer.id,
            endDate: replaceEndDate ? endDate : borrow.endDate, 
            status: replaceStatus ? status : borrow.status, 
            customer: replaceCustomer ? customer : borrow.customer, 
            book: replaceBook ? book : borrow.book
          )
        );

        CoreUtils.showToast(
          context, 
          type: ToastType.success, 
          title: 'Erfolgreich aktualisiert.',
          description: 'Die Ausleihe wurde erfolgreich aktualisiert.' 
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
      'Diese Ausleihe wirklich löschen?', 
      'Wenn Sie diese Ausleihe löschen, werden alle damit verbundenen Daten ebenfalls gelöscht. Dieser Vorgang kann nicht rückgängig gemacht werden.',
      'Löschen',
      onPressed: () async {
        final BorrowDeleteBorrowUsecase borrowDeleteBorrowUsecase = ref.read(borrowDeleteBorrowUsecaseProvider);
        final BorrowDeleteBorrowUsecaseParams borrowDeleteBorrowUsecaseParams = BorrowDeleteBorrowUsecaseParams(borrowId: widget.params.borrowId);
        final Result<void> borrowDeleteBorrowUsecaseResult = await borrowDeleteBorrowUsecase.call(borrowDeleteBorrowUsecaseParams);

        return borrowDeleteBorrowUsecaseResult.fold<bool>(
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
      book: CreateBorrowBook(
        id: _bookNotifier.value.id, 
        title: _bookNotifier.value.title,
        edition: _bookNotifier.value.edition
      )
    );

    if (newBook != null) {
      _bookNotifier.value = BorrowDetailsBookEntity(
        id: newBook.id,
        title: newBook.title,
        edition: newBook.edition
      );
    }
  }

  Future<void> _handleEditCustomer() async {
    CreateBorrowCustomer? newCustomer = await showCustomersSelectionDialog(
      context: context, 
      customer: CreateBorrowCustomer(
        id: _customerNotifier.value.id, 
        title: _customerNotifier.value.title,
        firstName: _customerNotifier.value.firstName, 
        lastName: _customerNotifier.value.lastName
      )
    );

    if (newCustomer != null) {
      _customerNotifier.value = BorrowDetailsCustomerEntity(
        id: newCustomer.id,
        title: newCustomer.title,
        firstName: newCustomer.firstName,
        lastName: newCustomer.lastName
      );
    }
  }

  @override
  void initState() {
    super.initState();

    CoreUtils.postFrameCall(() {
      ref.read(borrowDetailsPageNotifierProvider(widget.params.borrowId).notifier).fetch();
    });
  }

  @override
  Widget build(BuildContext context) {

    final BorrowDetailsPageState pageState = ref.watch(borrowDetailsPageNotifierProvider(widget.params.borrowId));

    if (pageState.hasBorrow) {
      _endDateNotifier = useState<DateTime>(pageState.borrow!.endDate);
      _statusNotifier = useState<BorrowStatus>(pageState.borrow!.status);
      _bookNotifier = useState<BorrowDetailsBookEntity>(pageState.borrow!.book);
      _customerNotifier = useState<BorrowDetailsCustomerEntity>(pageState.borrow!.customer);
    }

    ref.listen<BorrowDetailsPageState>(
      borrowDetailsPageNotifierProvider(widget.params.borrowId), 
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
            isEnabled: pageState.hasBorrow
          ),
          HBAppBarButton(
            onPressed: _onDelete,
            icon: HBIcons.trash,
            isEnabled: pageState.hasBorrow
          )
        ]
      ),
      body: pageState.hasBorrow
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
                'Allgemeine Details',
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: HBDateButton(
                      onChanged: _handleEndDateChanged,
                      title: 'Rückgabedatum',
                      dateTime: _endDateNotifier.value
                    )
                  ),
                  const HBGap.xl(),
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
                              isEnabled: pageState.hasBorrow,
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
                  ),
                  const HBGap.xl(),
                  const Spacer()
                ]
              ),
              const HBGap.xxl(),
              Text(
                'Leihinformationen',
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
                              isEnabled: pageState.hasBorrow,
                              textAlign: TextAlign.end,
                              title: 'Bearbeiten'
                            )
                          ]
                        ),
                        const HBGap.md(),
                        HBChip(
                          text: '${ _bookNotifier.value.title }${ _bookNotifier.value.edition != null ? ' (${ _bookNotifier.value.edition }. Auflage)' : '' }',
                          color: HBColors.gray900
                        )
                      ]
                    )
                  ),
                  const HBGap.xl(),
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
                              isEnabled: pageState.hasBorrow,
                              textAlign: TextAlign.end,
                              title: 'Bearbeiten'
                            )
                          ]
                        ),
                        const HBGap.md(),
                        HBChip(
                          text: '${ _customerNotifier.value.title != null ? '${ _customerNotifier.value.title } ' : '' }${ _customerNotifier.value.firstName } ${ _customerNotifier.value.lastName }',
                          color: HBColors.gray900
                        )
                      ]
                    )
                  ),
                  const HBGap.xl(),
                  const Spacer()
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
    );
  }
}
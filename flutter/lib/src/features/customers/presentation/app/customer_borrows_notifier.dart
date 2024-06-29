import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/core/common/models/error_details.dart';
import 'package:habib_app/src/features/customers/domain/entities/customer_borrow_entity.dart';
import 'package:habib_app/src/features/customers/domain/usecases/customer_get_customer_borrows_usecase.dart';
import 'package:habib_app/core/utils/constants/network_constants.dart';
import 'package:habib_app/core/utils/result.dart';

part 'customer_borrows_notifier.g.dart';

@riverpod
class CustomerBorrowsNotifier extends _$CustomerBorrowsNotifier {

  late CustomerGetCustomerBorrowsUsecase _customerGetCustomerBorrowsUsecase;

  @override
  CustomerBorrowsState build(int customerId) {
    _customerGetCustomerBorrowsUsecase = ref.read(customerGetCustomerBorrowsUsecaseProvider);
    return const CustomerBorrowsState();
  }

  Future<void> fetchNextPage(String searchText) async {
    if (state.isLoading || state.hasReachedEnd) return;
    
    state = state.copyWith(
      isCustomerBorrowsLoading: true,
      removeError: true
    );

    final CustomerGetCustomerBorrowsUsecaseParams params = CustomerGetCustomerBorrowsUsecaseParams(
      customerId: customerId,
      searchText: searchText,
      currentPage: state.currentPage
    );
    final Result<List<CustomerBorrowEntity>> result = await _customerGetCustomerBorrowsUsecase.call(params);
    
    result.fold(
      onSuccess: (List<CustomerBorrowEntity> customerBorrows) {
        state = state.copyWith(
          isCustomerBorrowsLoading: false,
          currentPage: customerBorrows.isEmpty 
            ? state.currentPage 
            : state.currentPage + 1,
          customerBorrows: List.of(state.customerBorrows)..addAll(customerBorrows),
          hasReachedEnd: customerBorrows.length < NetworkConstants.pageSize
        );
      },
      onFailure: (Object error, StackTrace stackTrace) {
        state = state.copyWith(
          isCustomerBorrowsLoading: false,
          error: ErrorDetails(
            error: error, 
            stackTrace: stackTrace
          )
        );
      }
    );
  }
  
  Future<void> refresh(String searchText) async {
    state = const CustomerBorrowsState();
    await fetchNextPage(searchText);
  }
}

class CustomerBorrowsState extends Equatable {

  final bool isCustomerBorrowsLoading;
  final ErrorDetails? error;
  final List<CustomerBorrowEntity> customerBorrows;
  final bool hasReachedEnd;
  final int currentPage;

  const CustomerBorrowsState({
    this.isCustomerBorrowsLoading = false,
    this.error,
    this.customerBorrows = const <CustomerBorrowEntity>[],
    this.hasReachedEnd = false,
    this.currentPage = 1
  });

  bool get hasError => error != null;
  bool get isLoading => isCustomerBorrowsLoading;
  bool get hasCustomerBorrows => customerBorrows.isNotEmpty;

  CustomerBorrowsState copyWith({
    bool? isCustomerBorrowsLoading = false,
    ErrorDetails? error,
    List<CustomerBorrowEntity>? customerBorrows,
    bool? hasReachedEnd,
    int? currentPage,
    bool removeError = false,
    bool removeCustomerBorrows = false
  }) {
    return CustomerBorrowsState(
      isCustomerBorrowsLoading: isCustomerBorrowsLoading ?? this.isCustomerBorrowsLoading,
      error: removeError ? null : error ?? this.error,
      customerBorrows: removeCustomerBorrows ? const <CustomerBorrowEntity>[] : customerBorrows ?? this.customerBorrows,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      currentPage: currentPage ?? this.currentPage
    );
  }

  @override
  List<Object?> get props => [
    isCustomerBorrowsLoading,
    error,
    customerBorrows,
    hasReachedEnd,
    currentPage
  ];
}
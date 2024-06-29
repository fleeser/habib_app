import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/core/common/models/error_details.dart';
import 'package:habib_app/src/features/customers/domain/entities/customer_entity.dart';
import 'package:habib_app/src/features/customers/domain/usecases/customer_get_customers_usecase.dart';
import 'package:habib_app/core/utils/constants/network_constants.dart';
import 'package:habib_app/core/utils/result.dart';

part 'customers_page_notifier.g.dart';

@riverpod
class CustomersPageNotifier extends _$CustomersPageNotifier {

  late CustomerGetCustomersUsecase _customerGetCustomersUsecase;

  @override
  CustomersPageState build() {
    _customerGetCustomersUsecase = ref.read(customerGetCustomersUsecaseProvider);
    return const CustomersPageState();
  }

  Future<void> fetchNextPage(String searchText) async {
    if (state.isLoading || state.hasReachedEnd) return;
    
    state = state.copyWith(
      isCustomersLoading: true,
      removeError: true
    );

    final CustomerGetCustomersUsecaseParams params = CustomerGetCustomersUsecaseParams(
      searchText: searchText,
      currentPage: state.currentPage
    );
    final Result<List<CustomerEntity>> result = await _customerGetCustomersUsecase.call(params);
    
    result.fold(
      onSuccess: (List<CustomerEntity> customers) {
        state = state.copyWith(
          isCustomersLoading: false,
          currentPage: customers.isEmpty 
            ? state.currentPage 
            : state.currentPage + 1,
          customers: List.of(state.customers)..addAll(customers),
          hasReachedEnd: customers.length < NetworkConstants.pageSize
        );
      },
      onFailure: (Object error, StackTrace stackTrace) {
        state = state.copyWith(
          isCustomersLoading: false,
          error: ErrorDetails(
            error: error, 
            stackTrace: stackTrace
          )
        );
      }
    );
  }
  
  Future<void> refresh(String searchText) async {
    state = const CustomersPageState();
    await fetchNextPage(searchText);
  }
}

class CustomersPageState extends Equatable {

  final bool isCustomersLoading;
  final ErrorDetails? error;
  final List<CustomerEntity> customers;
  final bool hasReachedEnd;
  final int currentPage;

  const CustomersPageState({
    this.isCustomersLoading = false,
    this.error,
    this.customers = const <CustomerEntity>[],
    this.hasReachedEnd = false,
    this.currentPage = 1
  });

  bool get hasError => error != null;
  bool get isLoading => isCustomersLoading;
  bool get hasCustomers => customers.isNotEmpty;

  CustomersPageState copyWith({
    bool? isCustomersLoading = false,
    ErrorDetails? error,
    List<CustomerEntity>? customers,
    bool? hasReachedEnd,
    int? currentPage,
    bool removeError = false,
    bool removeCustomers = false
  }) {
    return CustomersPageState(
      isCustomersLoading: isCustomersLoading ?? this.isCustomersLoading,
      error: removeError ? null : error ?? this.error,
      customers: removeCustomers ? const <CustomerEntity>[] : customers ?? this.customers,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      currentPage: currentPage ?? this.currentPage
    );
  }

  @override
  List<Object?> get props => [
    isCustomersLoading,
    error,
    customers,
    hasReachedEnd,
    currentPage
  ];
}
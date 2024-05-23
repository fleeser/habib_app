import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


import 'package:habib_app/src/features/customers/domain/entities/customer_entity.dart';
import 'package:habib_app/src/features/customers/domain/usecases/customer_get_customers_usecase.dart';
import 'package:habib_app/core/utils/constants/network_constants.dart';
import 'package:habib_app/core/utils/result.dart';

part 'customers_page_notifier.g.dart';

enum CustomersPageStatus {
  initial,
  loading,
  success,
  failure
}

class CustomersPageState extends Equatable {
  
  final CustomersPageStatus status;
  final Exception? exception;
  final List<CustomerEntity> customers;
  final bool hasReachedEnd;
  final int currentPage;

  const CustomersPageState({
    this.status = CustomersPageStatus.initial,
    this.exception,
    this.customers = const [],
    this.hasReachedEnd = false,
    this.currentPage = 1
  });

  CustomersPageState copyWith({
    CustomersPageStatus? status,
    Exception? exception,
    List<CustomerEntity>? customers,
    bool? hasReachedEnd,
    int? currentPage,
    bool removeException = false,
    bool removeCustomers = false
  }) {
    return CustomersPageState(
      status: status ?? this.status,
      exception: removeException ? null : exception ?? this.exception,
      customers: removeCustomers ? [] : customers ?? this.customers,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      currentPage: currentPage ?? this.currentPage
    );
  }

  @override
  List<Object?> get props => [
    status,
    exception,
    customers,
    hasReachedEnd,
    currentPage
  ];
}

@riverpod
class CustomersPageNotifier extends _$CustomersPageNotifier {

  late CustomerGetCustomersUsecase _customerGetCustomersUsecase;

  @override
  CustomersPageState build() {
    _customerGetCustomersUsecase = ref.read(customerGetCustomersUsecaseProvider);
    return const CustomersPageState();
  }

  Future<void> fetchNextPage(String searchText) async {
    if (state.status == CustomersPageStatus.loading) return;
    if (state.hasReachedEnd) return;

    state = state.copyWith(
      status: CustomersPageStatus.loading,
      removeException: true
    );

    final CustomerGetCustomersUsecaseParams params = CustomerGetCustomersUsecaseParams(
      searchText: searchText,
      currentPage: state.currentPage
    );
    final Result<List<CustomerEntity>> result = await _customerGetCustomersUsecase.call(params);
    
    result.fold(
      onSuccess: (List<CustomerEntity> customers) {
        state = state.copyWith(
          status: CustomersPageStatus.success,
          currentPage: customers.isEmpty 
            ? state.currentPage 
            : state.currentPage + 1,
          customers: List.of(state.customers)..addAll(customers),
          hasReachedEnd: customers.length < NetworkConstants.pageSize,
          removeException: true
        );
      }, 
      onFailure: (Exception exception, StackTrace stackTrace) {
        state = state.copyWith(
          status: CustomersPageStatus.failure,
          exception: exception
        );
      }
    );
  }
  
  Future<void> refresh(String searchText) async {
    state = const CustomersPageState();
    await fetchNextPage(searchText);
  }
}
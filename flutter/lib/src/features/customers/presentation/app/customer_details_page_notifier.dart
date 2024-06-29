import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/core/common/models/error_details.dart';
import 'package:habib_app/src/features/customers/domain/entities/customer_details_entity.dart';
import 'package:habib_app/src/features/customers/domain/usecases/customer_get_customer_usecase.dart';
import 'package:habib_app/core/utils/result.dart';

part 'customer_details_page_notifier.g.dart';

@riverpod
class CustomerDetailsPageNotifier extends _$CustomerDetailsPageNotifier {

  late CustomerGetCustomerUsecase _customerGetCustomerUsecase;

  @override
  CustomerDetailsPageState build(int customerId) {
    _customerGetCustomerUsecase = ref.read(customerGetCustomerUsecaseProvider);
    return const CustomerDetailsPageState();
  }

  void replace(CustomerDetailsEntity customer) {
    state = state.copyWith(customer: customer);
  }

  Future<void> fetch() async {
    if (state.isLoading) return;
    
    state = state.copyWith(
      isCustomerLoading: true,
      removeError: true
    );

    final CustomerGetCustomerUsecaseParams customerParams = CustomerGetCustomerUsecaseParams(customerId: customerId);
    final Result<CustomerDetailsEntity> result = await _customerGetCustomerUsecase.call(customerParams);
    
    result.fold(
      onSuccess: (CustomerDetailsEntity customer) {
        state = state.copyWith(
          isCustomerLoading: false,
          customer: customer
        );
      },
      onFailure: (Object error, StackTrace stackTrace) {
        state = state.copyWith(
          isCustomerLoading: false,
          error: ErrorDetails(
            error: error, 
            stackTrace: stackTrace
          )
        );
      }
    );
  }
}

class CustomerDetailsPageState extends Equatable {

  final bool isCustomerLoading;
  final ErrorDetails? error;
  final CustomerDetailsEntity? customer;

  const CustomerDetailsPageState({
    this.isCustomerLoading = false,
    this.error,
    this.customer
  });

  bool get hasError => error != null;
  bool get isLoading => isCustomerLoading;
  bool get hasCustomer => customer != null;

  CustomerDetailsPageState copyWith({
    bool? isCustomerLoading = false,
    ErrorDetails? error,
    CustomerDetailsEntity? customer,
    bool removeError = false,
    bool removeCustomer = false
  }) {
    return CustomerDetailsPageState(
      isCustomerLoading: isCustomerLoading ?? this.isCustomerLoading,
      error: removeError ? null : error ?? this.error,
      customer: removeCustomer ? null : customer ?? this.customer
    );
  }

  @override
  List<Object?> get props => [
    isCustomerLoading,
    error,
    customer
  ];
}
import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/src/features/customers/domain/repositories/customer_repository.dart';
import 'package:habib_app/core/usecase/usecase.dart';
import 'package:habib_app/core/utils/typedefs.dart';

part 'customer_delete_customer_usecase.g.dart';

@riverpod
CustomerDeleteCustomerUsecase customerDeleteCustomerUsecase(CustomerDeleteCustomerUsecaseRef ref) {
  return CustomerDeleteCustomerUsecase(
    customerRepository: ref.read(customerRepositoryProvider)
  );
}

class CustomerDeleteCustomerUsecase extends UsecaseWithParams<void, CustomerDeleteCustomerUsecaseParams> {

  final CustomerRepository _customerRepository;

  const CustomerDeleteCustomerUsecase({
    required CustomerRepository customerRepository
  })  : _customerRepository = customerRepository;

  @override
  ResultFuture<void> call(CustomerDeleteCustomerUsecaseParams params) async {
    return await _customerRepository.deleteCustomer(customerId: params.customerId);
  }
}

class CustomerDeleteCustomerUsecaseParams extends Equatable {

  final int customerId;

  const CustomerDeleteCustomerUsecaseParams({ required this.customerId });

  @override
  List<Object?> get props => [
    customerId
  ];
}
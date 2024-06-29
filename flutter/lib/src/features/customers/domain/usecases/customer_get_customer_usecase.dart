import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/src/features/customers/domain/entities/customer_details_entity.dart';
import 'package:habib_app/src/features/customers/domain/repositories/customer_repository.dart';
import 'package:habib_app/core/usecase/usecase.dart';
import 'package:habib_app/core/utils/typedefs.dart';

part 'customer_get_customer_usecase.g.dart';

@riverpod
CustomerGetCustomerUsecase customerGetCustomerUsecase(CustomerGetCustomerUsecaseRef ref) {
  return CustomerGetCustomerUsecase(
    customerRepository: ref.read(customerRepositoryProvider)
  );
}

class CustomerGetCustomerUsecase extends UsecaseWithParams<CustomerDetailsEntity, CustomerGetCustomerUsecaseParams> {

  final CustomerRepository _customerRepository;

  const CustomerGetCustomerUsecase({
    required CustomerRepository customerRepository
  })  : _customerRepository = customerRepository;

  @override
  ResultFuture<CustomerDetailsEntity> call(CustomerGetCustomerUsecaseParams params) async {
    return await _customerRepository.getCustomer(customerId: params.customerId);
  }
}

class CustomerGetCustomerUsecaseParams extends Equatable {

  final int customerId;

  const CustomerGetCustomerUsecaseParams({ required this.customerId });

  @override
  List<Object?> get props => [
    customerId
  ];
}
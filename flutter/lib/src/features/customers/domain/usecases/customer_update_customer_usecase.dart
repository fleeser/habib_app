import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/src/features/customers/domain/repositories/customer_repository.dart';
import 'package:habib_app/core/usecase/usecase.dart';
import 'package:habib_app/core/utils/typedefs.dart';

part 'customer_update_customer_usecase.g.dart';

@riverpod
CustomerUpdateCustomerUsecase customerUpdateCustomerUsecase(CustomerUpdateCustomerUsecaseRef ref) {
  return CustomerUpdateCustomerUsecase(
    customerRepository: ref.read(customerRepositoryProvider)
  );
}

class CustomerUpdateCustomerUsecase extends UsecaseWithParams<void, CustomerUpdateCustomerUsecaseParams> {

  final CustomerRepository _customerRepository;

  const CustomerUpdateCustomerUsecase({
    required CustomerRepository customerRepository
  })  : _customerRepository = customerRepository;

  @override
  ResultFuture<void> call(CustomerUpdateCustomerUsecaseParams params) async {
    return await _customerRepository.updateCustomer(
      customerId: params.customerId,
      addressId: params.addressId,
      customerJson: params.customerJson,
      addressJson: params.addressJson
    );
  }
}

class CustomerUpdateCustomerUsecaseParams extends Equatable {

  final int customerId;
  final int addressId;
  final Json customerJson;
  final Json addressJson;

  const CustomerUpdateCustomerUsecaseParams({ 
    required this.customerId,
    required this.addressId,
    required this.customerJson,
    required this.addressJson
  });

  @override
  List<Object?> get props => [
    customerId,
    addressId,
    customerJson,
    addressJson
  ];
}
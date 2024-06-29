import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/src/features/customers/domain/repositories/customer_repository.dart';
import 'package:habib_app/core/usecase/usecase.dart';
import 'package:habib_app/core/utils/typedefs.dart';

part 'customer_create_customer_usecase.g.dart';

@riverpod
CustomerCreateCustomerUsecase customerCreateCustomerUsecase(CustomerCreateCustomerUsecaseRef ref) {
  return CustomerCreateCustomerUsecase(
    customerRepository: ref.read(customerRepositoryProvider)
  );
}

class CustomerCreateCustomerUsecase extends UsecaseWithParams<int, CustomerCreateCustomerUsecaseParams> {

  final CustomerRepository _customerRepository;

  const CustomerCreateCustomerUsecase({
    required CustomerRepository customerRepository
  })  : _customerRepository = customerRepository;

  @override
  ResultFuture<int> call(CustomerCreateCustomerUsecaseParams params) async {
    return await _customerRepository.createCustomer(
      addressJson: params.addressJson,
      customerJson: params.customerJson
    );
  }
}

class CustomerCreateCustomerUsecaseParams extends Equatable {

  final Json addressJson;
  final Json customerJson;

  const CustomerCreateCustomerUsecaseParams({ 
    required this.addressJson,
    required this.customerJson
  });

  @override
  List<Object?> get props => [
    addressJson,
    customerJson
  ];
}
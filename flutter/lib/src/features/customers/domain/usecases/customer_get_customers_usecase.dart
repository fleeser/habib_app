import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/src/features/customers/domain/entities/customer_entity.dart';
import 'package:habib_app/src/features/customers/domain/repositories/customer_repository.dart';
import 'package:habib_app/core/usecase/usecase.dart';
import 'package:habib_app/core/utils/typedefs.dart';

part 'customer_get_customers_usecase.g.dart';

@riverpod
CustomerGetCustomersUsecase customerGetCustomersUsecase(CustomerGetCustomersUsecaseRef ref) {
  return CustomerGetCustomersUsecase(
    customerRepository: ref.read(customerRepositoryProvider)
  );
}

class CustomerGetCustomersUsecase extends UsecaseWithParams<List<CustomerEntity>, CustomerGetCustomersUsecaseParams> {

  final CustomerRepository _customerRepository;

  const CustomerGetCustomersUsecase({
    required CustomerRepository customerRepository
  })  : _customerRepository = customerRepository;

  @override
  ResultFuture<List<CustomerEntity>> call(CustomerGetCustomersUsecaseParams params) async {
    return await _customerRepository.getCustomers(currentPage: params.currentPage);
  }
}

class CustomerGetCustomersUsecaseParams extends Equatable {

  final int currentPage;

  const CustomerGetCustomersUsecaseParams({ required this.currentPage });

  @override
  List<Object?> get props => [
    currentPage
  ];
}
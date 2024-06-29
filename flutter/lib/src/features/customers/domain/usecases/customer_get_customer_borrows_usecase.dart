import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/src/features/customers/domain/entities/customer_borrow_entity.dart';
import 'package:habib_app/src/features/customers/domain/repositories/customer_repository.dart';
import 'package:habib_app/core/usecase/usecase.dart';
import 'package:habib_app/core/utils/typedefs.dart';

part 'customer_get_customer_borrows_usecase.g.dart';

@riverpod
CustomerGetCustomerBorrowsUsecase customerGetCustomerBorrowsUsecase(CustomerGetCustomerBorrowsUsecaseRef ref) {
  return CustomerGetCustomerBorrowsUsecase(
    customerRepository: ref.read(customerRepositoryProvider)
  );
}

class CustomerGetCustomerBorrowsUsecase extends UsecaseWithParams<List<CustomerBorrowEntity>, CustomerGetCustomerBorrowsUsecaseParams> {

  final CustomerRepository _customerRepository;

  const CustomerGetCustomerBorrowsUsecase({
    required CustomerRepository customerRepository
  })  : _customerRepository = customerRepository;

  @override
  ResultFuture<List<CustomerBorrowEntity>> call(CustomerGetCustomerBorrowsUsecaseParams params) async {
    return await _customerRepository.getCustomerBorrows(
      customerId: params.customerId,
      searchText: params.searchText,
      currentPage: params.currentPage
    );
  }
}

class CustomerGetCustomerBorrowsUsecaseParams extends Equatable {

  final int customerId;
  final String searchText;
  final int currentPage;

  const CustomerGetCustomerBorrowsUsecaseParams({ 
    required this.customerId,
    required this.searchText,
    required this.currentPage 
  });

  @override
  List<Object?> get props => [
    customerId,
    searchText,
    currentPage
  ];
}
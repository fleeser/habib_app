import 'package:equatable/equatable.dart';

class NewBooksBoughtEntity extends Equatable {

  final int month;
  final int boughtCount;
  final int notBoughtCount;

  const NewBooksBoughtEntity({
    required this.month,
    required this.boughtCount,
    required this.notBoughtCount
  });

  @override
  List<Object?> get props => [
    month,
    boughtCount,
    notBoughtCount
  ];
}
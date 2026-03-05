import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_of_heaven/core/error/failure.dart';

import 'package:slice_of_heaven/core/usecase/app_usecase.dart';
import 'package:slice_of_heaven/features/home/data/repositories/home_repository.dart';
import 'package:slice_of_heaven/features/home/domain/entities/pizza_entity.dart';
import 'package:slice_of_heaven/features/home/domain/repositories/home_repository.dart';

// Provider
final getAllPizzasUsecaseProvider =
    Provider<GetAllPizzasUsecase>((ref) {
  final repository = ref.read(homeRepositoryProvider);
  return GetAllPizzasUsecase(homeRepository: repository);
});

class GetAllPizzasUsecase
    implements UsecaseWithoutParams<List<PizzaEntity>> {
  final IHomeRepository _homeRepository;

  GetAllPizzasUsecase({
    required IHomeRepository homeRepository,
  }) : _homeRepository = homeRepository;

  @override
  Future<Either<Failure, List<PizzaEntity>>> call() {
    return _homeRepository.getAllPizzas();
  }
}
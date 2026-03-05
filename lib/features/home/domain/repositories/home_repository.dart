import 'package:dartz/dartz.dart';
import 'package:slice_of_heaven/core/error/failure.dart';
import 'package:slice_of_heaven/features/home/domain/entities/pizza_entity.dart';

abstract interface class IHomeRepository {
  Future<Either<Failure, List<PizzaEntity>>> getAllPizzas();
}
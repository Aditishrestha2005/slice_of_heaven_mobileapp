import 'package:dartz/dartz.dart';
import 'package:slice_of_heaven/core/error/failure.dart';



abstract interface class UsecaseWithParams<SuccessType,Params>{
  Future<Either<Failure, SuccessType>> call(Params params);
}

abstract interface class UsecaseWithoutParams<SuccessType> {
  Future<Either<Failure, SuccessType>> call();
}

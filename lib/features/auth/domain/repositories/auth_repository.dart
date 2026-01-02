import 'package:dartz/dartz.dart';
import 'package:slice_of_heaven/core/error/failure.dart';

import '../entities/auth_entity.dart';

abstract class IAuthRepository {
  Future<Either<Failure, bool>> register(AuthEntity user);
  Future<Either<Failure, AuthEntity>> login(String email, String password);
  Future<Either<Failure, AuthEntity>> getUserByEmail(String email);
  Future<Either<Failure, bool>> logout();
  Future<Either<Failure, AuthEntity>> getCurrentUser();
}
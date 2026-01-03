
// import 'package:dartz/dartz.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:slice_of_heaven/core/error/failure.dart';
// import 'package:slice_of_heaven/features/auth/data/repositories/auth_repository.dart';

// import '../entities/auth_entity.dart';
// import '../repositories/auth_repository.dart';

// final getUserByEmailProvider = Provider(
//   (ref) => GetUserByEmailUsecase(ref.read(authRepositoryProvider)),
// );

// class GetUserByEmailUsecase {
//   final IAuthRepository repository;
//   GetUserByEmailUsecase(this.repository);
//   Future<Either<Failure, AuthEntity>> call(String email) {
//     return repository.getUserByEmail(email);
//   }
// }
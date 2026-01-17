import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_of_heaven/core/error/failure.dart';
import 'package:slice_of_heaven/core/usecase/app_usecase.dart';
import 'package:slice_of_heaven/features/auth/data/repositories/auth_repository.dart';
import 'package:slice_of_heaven/features/auth/domain/entities/auth_entity.dart';
import 'package:slice_of_heaven/features/auth/domain/repositories/auth_repository.dart';


final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return GetCurrentUserUseCase(authRepository: authRepository);
});

class GetCurrentUserUseCase implements UsecaseWithoutParams<AuthEntity> {
  final IAuthRepository _authRepository;

  GetCurrentUserUseCase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, AuthEntity>> call() {
    return _authRepository.getCurrentUser();
  }
}
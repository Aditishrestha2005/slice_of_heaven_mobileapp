import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_of_heaven/core/error/failure.dart';
import 'package:slice_of_heaven/core/usecase/app_usecase.dart';
import 'package:slice_of_heaven/features/auth/data/repositories/auth_repository.dart';
import 'package:slice_of_heaven/features/auth/domain/repositories/auth_repository.dart';

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return LogoutUseCase(authRepository: repo);
});

class LogoutUseCase implements UsecaseWithoutParams<bool> {
  final IAuthRepository _authRepository;

  LogoutUseCase({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  @override
  Future<Either<Failure, bool>> call() {
    return _authRepository.logout();
  }
}
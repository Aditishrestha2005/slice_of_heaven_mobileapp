

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_of_heaven/core/error/failure.dart';
import 'package:slice_of_heaven/core/usecase/app_usecase.dart';
import 'package:slice_of_heaven/features/auth/data/repositories/auth_repository.dart';
import 'package:slice_of_heaven/features/auth/domain/entities/auth_entity.dart';
import 'package:slice_of_heaven/features/auth/domain/repositories/auth_repository.dart';

class RegisterUsecaseParams extends Equatable {
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? batchId;
  final String username;
  final String password;

  const RegisterUsecaseParams({
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.batchId,
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [
    fullName,
    email,
    phoneNumber,
    batchId,
    username,
    password,
  ];
}

//Provider
final registerUsercaseProvider = Provider<RegisterUsecase>((ref){
  final authRepository = ref.read(authRepositoryProvider);
  return RegisterUsecase(authRepository: authRepository);
});

class RegisterUsecase implements UsecaseWithParms<bool,RegisterUsecaseParams>{

  final IAuthRepository _authRepository;
  RegisterUsecase({required IAuthRepository authRepository}) 
  :_authRepository = authRepository;

  @override
  Future<Either<Failure, bool>> call(RegisterUsecaseParams params) {
    final entity = AuthEntity(
      fullName: params.fullName, 
      email: params.email, 
      phoneNumber: params.phoneNumber,
      batchId: params.batchId,
      username: params.username,
      password: params.password,
    );
    return  _authRepository.register(entity);
  }
}
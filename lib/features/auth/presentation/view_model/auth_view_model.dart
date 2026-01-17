import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_of_heaven/features/auth/domain/usecases/login_usecase.dart';
import 'package:slice_of_heaven/features/auth/domain/usecases/register_usecase.dart';
import 'package:slice_of_heaven/features/auth/presentation/state/auth_state.dart';

import 'package:uuid/uuid.dart';



final authViewModelProvider = NotifierProvider<AuthViewModel,AuthState>(
    ()=>AuthViewModel());

class AuthViewModel extends Notifier<AuthState>{
    late final RegisterUsecase _registerUsecase;
    late final LoginUseCase _loginUsecase;

    
  @override
  AuthState build() {
    _registerUsecase = ref.read(registerUsercaseProvider);
    _loginUsecase = ref.read(loginUseCaseProvider);
    return AuthState();
  }
  Future<void> register({
    required String fullName,
    required String email,
    required String username,
  
    required String password, required String confirmPassword,
    }) async {
        state = state.copyWith(status: AuthStatus.loading);
        //wait for 2 seconds
        await Future.delayed(Duration(seconds:2));
        final uuid = Uuid();
        final params = RegisterUsecaseParams(
        authId: uuid.v4(),
        fullName: fullName,
        email: email,
        username: username,
    
        password: password,
    );

  final result = await _registerUsecase(params);
  result.fold(
    (failure) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      );
    },
    (isRegistered) {
        state = state.copyWith(status: AuthStatus.registered);
    },
  );
  }

  Future<void> login({
  required String email,
  required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
  
  final params = LoginParams(
    email: email,
    password: password,
  );
  await Future.delayed(Duration(seconds:2));

  final result = await _loginUsecase(params);
  result.fold(
    (failure) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      );
    },
    (authEntity) {
      state = state.copyWith(
        status: AuthStatus.authenticated,
        authEntity: authEntity,
      );
    },
  );
  }
    }
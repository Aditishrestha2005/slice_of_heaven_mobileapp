import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_of_heaven/features/auth/domain/usecases/login_usecase.dart';
import 'package:slice_of_heaven/features/auth/domain/usecases/register_usecase.dart';
import 'package:slice_of_heaven/features/auth/presentation/state/auth_state.dart';



final authViewModelProvider = NotifierProvider<AuthViewModel,AuthState>(
    ()=>AuthViewModel());

class AuthViewModel extends Notifier<AuthState>{
    late final RegisterUsecase _registerUsecase;
    late final LoginUsecase _loginUsecase;

    
  @override
  AuthState build() {
    _registerUsecase = ref.read(registerUsercaseProvider);
    _loginUsecase = ref.read(loginUsecaseProvider);
    return AuthState();
  }
  Future<void> register({
    required String fullName,
    required String email,
    required String username,
    String? batchId,
    String? phoneNumber,
    required String password,
    }) async {
        state = state.copyWith(status: AuthStatus.loading);
        //wait for 2 seconds
        await Future.delayed(Duration(seconds:2));
        final params = RegisterUsecaseParams(
        fullName: fullName,
        email: email,
        username: username,
        batchId: batchId,
        phoneNumber: phoneNumber,
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
  
  final params = LoginUsecaseParams(
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
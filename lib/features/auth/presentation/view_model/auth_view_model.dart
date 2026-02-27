import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_of_heaven/core/services/storage/token_service.dart';
import 'package:slice_of_heaven/core/services/storage/user_session_service.dart';
import 'package:slice_of_heaven/features/auth/domain/entities/auth_entity.dart';
import 'package:slice_of_heaven/features/auth/domain/usecases/login_usecase.dart';
import 'package:slice_of_heaven/features/auth/domain/usecases/register_usecase.dart';
import 'package:slice_of_heaven/features/auth/presentation/state/auth_state.dart';
import 'package:uuid/uuid.dart';

final authViewModelProvider =
    NotifierProvider<AuthViewModel, AuthState>(AuthViewModel.new);

class AuthViewModel extends Notifier<AuthState> {
  late final RegisterUsecase _registerUsecase;
  late final LoginUseCase _loginUsecase;
  late final UserSessionService _userSessionService;
  late final TokenService _tokenService;

  @override
  AuthState build() {
    _registerUsecase = ref.read(registerUsercaseProvider);
    _loginUsecase = ref.read(loginUseCaseProvider);
    _userSessionService = ref.read(userSessionServiceProvider);
    _tokenService = ref.read(tokenServiceProvider);

    if (_userSessionService.isLoggedIn()) {
      final authEntity = AuthEntity(
        authId: _userSessionService.getCurrentUserId(),
        fullName: _userSessionService.getCurrentUserFullName() ?? '',
        email: _userSessionService.getCurrentUserEmail() ?? '',
        username: _userSessionService.getCurrentUserUsername() ?? '',
        phoneNumber: _userSessionService.getCurrentUserPhoneNumber(),
        profilePicture: _userSessionService.getCurrentUserProfilePicture(),
      );

      return AuthState(
        status: AuthStatus.authenticated,
        authEntity: authEntity,
      );
    }

    return const AuthState();
  }

  Future<void> register({
    required String fullName,
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
    required String phone,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);

    await Future.delayed(const Duration(seconds: 2));

    final uuid = const Uuid();
    final params = RegisterUsecaseParams(
      authId: uuid.v4(),
      fullName: fullName,
      email: email,
      username: username,
      password: password,
      confirmPassword: confirmPassword, // ✅ FIX
      phoneNumber: phone,
    );

    final result = await _registerUsecase(params);

    await result.fold(
      (failure) async {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (ok) async {
        await _userSessionService.saveUserSession(
          userId: params.authId,
          email: params.email,
          fullName: params.fullName,
          username: params.username,
          phoneNumber: params.phoneNumber,
        );

        final authEntity = AuthEntity(
          authId: params.authId,
          fullName: params.fullName,
          email: params.email,
          username: params.username,
          phoneNumber: params.phoneNumber,
        );

        state = state.copyWith(
          status: AuthStatus.authenticated,
          authEntity: authEntity,
        );
      },
    );
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);

    await Future.delayed(const Duration(seconds: 2));

    final params = LoginParams(email: email, password: password);
    final result = await _loginUsecase(params);

    await result.fold(
      (failure) async {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (authEntity) async {
        await _userSessionService.saveUserSession(
          userId: authEntity.authId ?? '',
          email: authEntity.email,
          fullName: authEntity.fullName,
          username: authEntity.username,
          phoneNumber: authEntity.phoneNumber,
          profilePicture: authEntity.profilePicture,
        );

        state = state.copyWith(
          status: AuthStatus.authenticated,
          authEntity: authEntity,
        );
      },
    );
  }

  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.loading);
    await Future.delayed(const Duration(seconds: 1));
    await _userSessionService.clearSession();
    await _tokenService.removeToken();

    state = state.copyWith(
      status: AuthStatus.unauthenticated,
      authEntity: null,
    );
  }
}

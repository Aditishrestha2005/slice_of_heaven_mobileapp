import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_of_heaven/core/error/failure.dart';
import 'package:slice_of_heaven/core/services/connectivity/network_info.dart';
import 'package:slice_of_heaven/features/auth/data/datasources/local/auth_local_datascource.dart';
import 'package:slice_of_heaven/features/auth/data/datasources/remote/auth_datasource.dart';
import 'package:slice_of_heaven/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:slice_of_heaven/features/auth/data/models/auth_api_model.dart';
import 'package:slice_of_heaven/features/auth/data/models/auth_hive_model.dart';
import 'package:slice_of_heaven/features/auth/domain/entities/auth_entity.dart';
import 'package:slice_of_heaven/features/auth/domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final localDatasource = ref.read(authLocalDataSourceProvider);
  final remoteDatasource = ref.read(authRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);

  return AuthRepository(
    authDatasource: localDatasource,
    authRemoteDatasource: remoteDatasource,
    networkInfo: networkInfo,
  );
});

class AuthRepository implements IAuthRepository {
  final IAuthLocalDataSource _authDatasource;
  final IAuthRemoteDataSource _authRemoteDatasource;
  final INetworkInfo _networkInfo;

  AuthRepository({
    required IAuthLocalDataSource authDatasource,
    required IAuthRemoteDataSource authRemoteDatasource,
    required INetworkInfo networkInfo,
  })  : _authDatasource = authDatasource,
        _authRemoteDatasource = authRemoteDatasource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, bool>> register(
    AuthEntity user, {
    required String confirmPassword,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = AuthApiModel.fromEntity(user);

        await _authRemoteDatasource.register(
          apiModel,
          password: user.password ?? '',
          confirmPassword: confirmPassword,
        );

        // optional: cache locally
        await _authDatasource.register(AuthHiveModel.fromEntity(user));
        return const Right(true);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data?['message']?.toString() ??
                'Registration failed',
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    }

    // OFFLINE register
    try {
      final existingUser = await _authDatasource.getUserByEmail(user.email);
      if (existingUser != null) {
        return const Left(LocalDatabaseFailure(message: "Email already registered"));
      }

      await _authDatasource.register(AuthHiveModel.fromEntity(user));
      return const Right(true);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> login(String email, String password) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = await _authRemoteDatasource.login(email, password);
        if (apiModel == null) {
          return const Left(ApiFailure(message: "Invalid credentials"));
        }

        final entity = apiModel.toEntity();

        // optional cache
        await _authDatasource.register(AuthHiveModel.fromEntity(entity));

        return Right(entity);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data?['message']?.toString() ?? 'Login failed',
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    }

    // OFFLINE login
    try {
      final user = await _authDatasource.login(email, password);
      if (user == null) {
        return const Left(LocalDatabaseFailure(message: "Invalid credentials"));
      }
      return Right(user.toEntity());
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() async {
    try {
      final user = await _authDatasource.getCurrentUser();
      if (user == null) {
        return const Left(LocalDatabaseFailure(message: "No user logged in"));
      }
      return Right(user.toEntity());
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      final ok = await _authDatasource.logout();
      if (!ok) {
        return const Left(LocalDatabaseFailure(message: "Failed to logout"));
      }
      return const Right(true);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> getUserByEmail(String email) async {
    try {
      final user = await _authDatasource.getUserByEmail(email);
      if (user == null) {
        return const Left(LocalDatabaseFailure(message: "No user found with this email"));
      }
      return Right(user.toEntity());
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}

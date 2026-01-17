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
  final autDataSource = ref.read(authLocalDataSourceProvider) as IAuthLocalDataSource;
  final remoteDatasource = ref.read(authRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);

  return AuthRepository(
    authDatasource:autDataSource,
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
  Future<Either<Failure, bool>> register(AuthEntity user) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = AuthApiModel.fromEntity(user);
        await _authRemoteDatasource.register(apiModel);

        // Optionally save user locally after remote registration
        await _authDatasource.register(AuthHiveModel.fromEntity(user));

        return const Right(true);
      } on DioException catch (e) {
        return Left(ApiFailure(
          message: e.response?.data['message'] ?? 'Registration failed',
          statusCode: e.response?.statusCode,
        ));
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        // Offline registration in Hive
        final existingUser = await _authDatasource.getUserByEmail(user.email);
        if (existingUser != null) {
          return const Left(LocalDatabaseFailure(message: "Email already registered"));
        }

        final hiveModel = AuthHiveModel.fromEntity(user);
        await _authDatasource.register(hiveModel);
        return const Right(true);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  
  @override
  Future<Either<Failure, AuthEntity>> login(String email, String password) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = await _authRemoteDatasource.login(email, password);

        if (apiModel != null) {
          // Save to local Hive + session
          await _authDatasource.register(AuthHiveModel.fromEntity(apiModel.toEntity()));
          return Right(apiModel.toEntity());
        }
        return const Left(LocalDatabaseFailure(message: "Invalid credentials"));
      } on DioException catch (e) {
        return Left(ApiFailure(
          message: e.response?.data['message'] ?? 'Login failed',
          statusCode: e.response?.statusCode,
        ));
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }

    // Offline login
    try {
      final hiveModel = await _authDatasource.getUserByEmail(email);
      if (hiveModel != null && hiveModel.password == password) {
        return Right(hiveModel.toEntity());
      }
      return const Left(LocalDatabaseFailure(message: "Invalid credentials"));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() async {
    try {
      final user = await _authDatasource.getCurrentUser();
      if (user != null) return Right(user.toEntity());
      return const Left(LocalDatabaseFailure(message: "No user logged in"));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }


  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      final result = await _authDatasource.logout();
      if (result) return const Right(true);
      return const Left(LocalDatabaseFailure(message: "Failed to logout"));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }


  @override
  Future<Either<Failure, AuthEntity>> getUserByEmail(String email) async {
    try {
      final user = await _authDatasource.getUserByEmail(email);
      if (user != null) return Right(user.toEntity());
      return const Left(LocalDatabaseFailure(message: "No user is found with this email"));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
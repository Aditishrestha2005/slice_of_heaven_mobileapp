import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_of_heaven/core/error/failure.dart';
import 'package:slice_of_heaven/core/services/connectivity/network_info.dart';
import 'package:slice_of_heaven/features/profile/data/datasources/local/profile_local_datasource.dart';
import 'package:slice_of_heaven/features/profile/data/datasources/profile_datasource.dart';
import 'package:slice_of_heaven/features/profile/data/datasources/remote/profile_remote_datasource.dart';
import 'package:slice_of_heaven/features/profile/data/models/profile_hive_model.dart';
import 'package:slice_of_heaven/features/profile/domain/entities/profile_entity.dart';
import 'package:slice_of_heaven/features/profile/domain/repositories/profile_repository.dart';

final profileRepositoryProvider = Provider<IProfileRepository>((ref) {
  final local = ref.read(profileLocalDatasourceProvider);
  final remote = ref.read(profileRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);

  return ProfileRepositoryImpl(
    local: local,
    remote: remote,
    networkInfo: networkInfo,
  );
});

class ProfileRepositoryImpl implements IProfileRepository {
  final IProfileLocalDataSource _local;
  final IProfileRemoteDataSource _remote;
  final INetworkInfo _networkInfo;

  ProfileRepositoryImpl({
    required IProfileLocalDataSource local,
    required IProfileRemoteDataSource remote,
    required INetworkInfo networkInfo,
  })  : _local = local,
        _remote = remote,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, ProfileEntity>> getCurrentUserProfile() async {
    try {
      final model = await _local.getCurrentUserProfile();
      if (model == null) {
        return const Left(LocalDatabaseFailure(message: "No profile found"));
      }
      return Right(model.toEntity());
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  /// ✅ Updated: supports backend upload too
  @override
  Future<Either<Failure, bool>> updateProfile(
    ProfileEntity profile, {
    File? profilePictureFile,
  }) async {
    try {
      if (profile.userId == null || profile.userId!.isEmpty) {
        return const Left(LocalDatabaseFailure(message: "User ID missing"));
      }

      // 1) Remote update (if online)
      if (await _networkInfo.isConnected) {
        try {
          final ok = await _remote.updateProfileRemote(
            fullName: profile.fullName,
            email: profile.email,
            phoneNumber: profile.phoneNumber,
            profilePicture: profilePictureFile,
          );

          if (!ok) {
            return const Left(ApiFailure(message: "Backend profile update failed"));
          }
        } catch (e) {
          // If backend fails, return API failure (so you know real reason)
          return Left(ApiFailure(message: e.toString()));
        }
      }

      // 2) Local Hive update (UPSERT now works)
      final model = ProfileHiveModel.fromEntity(profile);
      final localOk = await _local.updateProfile(model);

      if (!localOk) {
        return const Left(LocalDatabaseFailure(message: "Failed to update profile (local)"));
      }

      return const Right(true);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}

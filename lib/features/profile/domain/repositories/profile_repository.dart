import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:slice_of_heaven/core/error/failure.dart';
import 'package:slice_of_heaven/features/profile/domain/entities/profile_entity.dart';

abstract interface class IProfileRepository {
  Future<Either<Failure, ProfileEntity>> getCurrentUserProfile();

  Future<Either<Failure, bool>> updateProfile(
    ProfileEntity profile, {
    File? profilePictureFile,
  });
}

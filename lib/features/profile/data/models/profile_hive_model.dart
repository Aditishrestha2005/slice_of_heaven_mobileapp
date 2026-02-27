import 'package:hive/hive.dart';
import 'package:slice_of_heaven/core/constants/hive_table_constant.dart';
import 'package:slice_of_heaven/features/profile/domain/entities/profile_entity.dart';
import 'package:uuid/uuid.dart';

part 'profile_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.profileTypeId)
class ProfileHiveModel extends HiveObject {
  @HiveField(0)
  final String? userId;

  @HiveField(1)
  final String fullName;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String? phoneNumber;

  @HiveField(4)
  final String? profilePicture;

  ProfileHiveModel({
    String? userId,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.profilePicture,
  }) : userId = userId ?? const Uuid().v4();

  // ================= TO ENTITY =================
  ProfileEntity toEntity() {
    return ProfileEntity(
      userId: userId,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      profilePicture: profilePicture,
    );
  }

  // ================= FROM ENTITY =================
  factory ProfileHiveModel.fromEntity(ProfileEntity entity) {
    return ProfileHiveModel(
      userId: entity.userId,
      fullName: entity.fullName,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      profilePicture: entity.profilePicture,
    );
  }

  // ================= TO ENTITY LIST =================
  static List<ProfileEntity> toEntityList(List<ProfileHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}

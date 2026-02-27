import 'package:flutter_test/flutter_test.dart';
import 'package:slice_of_heaven/features/auth/data/models/auth_hive_model.dart';
import 'package:slice_of_heaven/features/auth/domain/entities/auth_entity.dart';

void main() {
  group('AuthHiveModel Unit Tests', () {

    // Test 1: Model should store provided values correctly
    test('AuthHiveModel stores user data correctly', () {
      final model = AuthHiveModel(
        fullName: 'Ramesh Adhikari',
        email: 'ramesh@demo.com',
        username: 'ramesh_a',
        phoneNumber: '9801112233',
        password: 'Pass@123',
      );

      expect(model.fullName, 'Ramesh Adhikari');
      expect(model.email, 'ramesh@demo.com');
      expect(model.username, 'ramesh_a');
      expect(model.phoneNumber, '9801112233');
      expect(model.password, 'Pass@123');
    });

    // Test 2: authId should be auto-generated when not provided
    test('AuthHiveModel generates authId automatically', () {
      final model = AuthHiveModel(
        fullName: 'Auto User',
        email: 'auto@demo.com',
        username: 'auto_user',
      );

      expect(model.authId.isNotEmpty, true);
    });

    // Test 3: toEntity should convert Hive model to AuthEntity
    test('toEntity converts AuthHiveModel to AuthEntity', () {
      final model = AuthHiveModel(
        authId: 'hive_001',
        fullName: 'Sujita Rai',
        email: 'sujita@demo.com',
        username: 'sujita_r',
        phoneNumber: '9812345678',
      );

      final entity = model.toEntity();

      expect(entity.authId, 'hive_001');
      expect(entity.fullName, 'Sujita Rai');
      expect(entity.email, 'sujita@demo.com');
      expect(entity.username, 'sujita_r');
      expect(entity.phoneNumber, '9812345678');
    });

    // Test 4: fromEntity should create Hive model from AuthEntity
    test('fromEntity creates AuthHiveModel from AuthEntity', () {
      final entity = AuthEntity(
        authId: 'entity_777',
        fullName: 'Bimal Thapa',
        email: 'bimal@demo.com',
        username: 'bimal_t',
        phoneNumber: '9809988776',
        password: 'Hello@777',
      );

      final model = AuthHiveModel.fromEntity(entity);

      expect(model.authId, 'entity_777');
      expect(model.fullName, 'Bimal Thapa');
      expect(model.email, 'bimal@demo.com');
      expect(model.username, 'bimal_t');
      expect(model.phoneNumber, '9809988776');
      expect(model.password, 'Hello@777');
    });

    // Test 5: profilePicture should be null when not provided
    test('profilePicture should be null by default', () {
      final model = AuthHiveModel(
        fullName: 'No Image',
        email: 'noimage@demo.com',
        username: 'no_image_user',
      );

      expect(model.profilePicture, null);
    });

  });
}

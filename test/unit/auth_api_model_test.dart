import 'package:flutter_test/flutter_test.dart';
import 'package:slice_of_heaven/features/auth/data/models/auth_api_model.dart';
import 'package:slice_of_heaven/features/auth/domain/entities/auth_entity.dart';

void main() {
  group('AuthApiModel Unit Tests', () {
    // 1) fromJson should compose fullName from firstName + lastName and prefer _id
    test('fromJson composes fullName from firstName/lastName and reads _id', () {
      final json = {
        '_id': 'mongo_001',
        'firstName': 'Nisha',
        'lastName': 'Karki',
        'email': 'nisha.karki@demo.com',
        'username': 'nisha_k',
        'phoneNumber': '9801122334',
        'token': 'tkn_abc',
        'profilePicture': 'profile.png',
      };

      final model = AuthApiModel.fromJson(json);

      expect(model.id, 'mongo_001');
      expect(model.fullName, 'Nisha Karki');
      expect(model.email, 'nisha.karki@demo.com');
      expect(model.username, 'nisha_k');
      expect(model.phoneNumber, '9801122334');
      expect(model.token, 'tkn_abc');
      expect(model.profilePicture, 'profile.png');
    });

    // 2) fromJson should fallback to fullName when firstName/lastName are missing
    test('fromJson uses fullName when firstName/lastName are empty', () {
      final json = {
        'id': 'user_002',
        'fullName': 'Rohan Thapa',
        'email': 'rohan.thapa@demo.com',
        'username': 'rohan_t',
      };

      final model = AuthApiModel.fromJson(json);

      expect(model.id, 'user_002');
      expect(model.fullName, 'Rohan Thapa');
      expect(model.email, 'rohan.thapa@demo.com');
      expect(model.username, 'rohan_t');
      expect(model.phoneNumber, isNull);
      expect(model.token, isNull);
      expect(model.profilePicture, isNull);
    });

    // 3) toRegisterJson should split fullName into firstName and lastName
    test('toRegisterJson splits fullName into firstName and lastName', () {
      final model = AuthApiModel(
        fullName: 'Suman Raj Shrestha',
        email: 'suman.shrestha@demo.com',
        username: 'suman_rs',
        phoneNumber: '9811223344',
      );

      final json = model.toRegisterJson(
        password: 'MyPass@123',
        confirmPassword: 'MyPass@123',
      );

      expect(json['firstName'], 'Suman');
      expect(json['lastName'], 'Raj Shrestha');
      expect(json['email'], 'suman.shrestha@demo.com');
      expect(json['username'], 'suman_rs');
      expect(json['password'], 'MyPass@123');
      expect(json['confirmPassword'], 'MyPass@123');
      expect(json['phoneNumber'], '9811223344');
    });

    // 4) toLoginJson should return correct email/password map
    test('toLoginJson returns email and password map', () {
      final json = AuthApiModel.toLoginJson(
        email: 'login.user@demo.com',
        password: 'Login@456',
      );

      expect(json['email'], 'login.user@demo.com');
      expect(json['password'], 'Login@456');
      expect(json.length, 2);
    });

    // 5) Entity conversion round-trip: model -> entity -> model keeps same values
    test('toEntity and fromEntity preserve values', () {
      final model = AuthApiModel(
        id: 'auth_777',
        fullName: 'Bikash Gurung',
        email: 'bikash.g@demo.com',
        username: 'bikash_g',
        phoneNumber: '9800001112',
        token: 'token_xyz',
        profilePicture: 'bikash.jpg',
      );

      final AuthEntity entity = model.toEntity();
      final AuthApiModel model2 = AuthApiModel.fromEntity(entity);

      expect(model2.id, 'auth_777');
      expect(model2.fullName, 'Bikash Gurung');
      expect(model2.email, 'bikash.g@demo.com');
      expect(model2.username, 'bikash_g');
      expect(model2.phoneNumber, '9800001112');
      expect(model2.token, 'token_xyz');
      expect(model2.profilePicture, 'bikash.jpg');
    });
  });
}

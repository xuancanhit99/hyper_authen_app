import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hyper_authen_app/core/utils/typedef.dart';
import 'package:hyper_authen_app/src/auth/data/models/user_model.dart';
import 'package:hyper_authen_app/src/auth/domain/entities/user.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const cModel = UserModel.empty();

  test('should be a subclass of [User] entity', () {
    // Arrange
    // Act
    // Assert
    expect(cModel, isA<User>());
  });

  final cJson = fixture('user.json');
  final cMap = jsonDecode(cJson) as DataMap;

  // print(cMap);


  group('fromMap', () {
    test('should return a [UserModel] with the right data', () {
      // Arrange
      // Act

      final result = UserModel.fromMap(cMap);

      // Assert
      expect(result, equals(cModel));
    });
  });


  group('fromJson', () {
    test('should return a [UserModel] with the right data', () {
      // Arrange
      // Act
      final result = UserModel.fromJson(cJson);

      // Assert
      expect(result, equals(cModel));
    });
  });

  group('toMap', () {
    test('should return a [Map] with the right data', () {
      // Arrange
      // Act
      final result = cModel.toMap();

      // Assert
      expect(result, equals(cMap));
    });
  });

  group('toJson', () {
    test('should return a [Json] string with the right data', () {
      // Arrange
      // Act
      final result = cModel.toJson();
      final cJson = jsonEncode({
        'id': '1',
        'createdAt': '_empty.createdAt',
        'name': '_empty.name',
        'avatar': '_empty.avatar'
      });

      // Assert
      expect(result, equals(cJson));
    });
  });

  group('copyWith', ()
  {
    test('should return a [UserModel] with the right data', () {
      // Arrange
      // Act
      final result = cModel.copyWith(
        name: 'Henry',
      );

      // Assert
      expect(result.name, equals('Henry'));
    });
  });
}

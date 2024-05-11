import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:hyper_authen_app/core/errors/exceptions.dart';
import 'package:hyper_authen_app/core/utils/constants.dart';
import 'package:hyper_authen_app/src/auth/data/datasources/auth_remote_data_source.dart';
import 'package:hyper_authen_app/src/auth/data/models/user_model.dart';
import 'package:mocktail/mocktail.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  late http.Client client;
  late AuthenticationRemoteDataSource remoteDataSource;

  setUp(() {
    client = MockClient();
    remoteDataSource = AuthenticationRemoteDataSourceImplementation(client);
    registerFallbackValue(Uri());
  });

  group('createUser', () {
    test('should complete successfully when the status code is 200 or 201',
        () async {
      // arrange
      when(
        () => client.post(
          any(),
          body: any(named: 'body'),
        ),
      ).thenAnswer(
        (_) async =>
            http.Response('{"message": "User created successfully"}', 201),
      );

      // act
      final methodCall = remoteDataSource.createUser;

      // assert
      expect(
        methodCall(
          createdAt: 'createdAt',
          name: 'name',
          avatar: 'avatar',
        ),
        completes,
      );

      verify(
        () => client.post(
          Uri.https(cBaseUrl, cCreateUserEndpoint),
          body: {
            'createdAt': 'createdAt',
            'name': 'name',
            'avatar': 'avatar',
          },
        ),
      ).called(1);

      verifyNoMoreInteractions(client);
    });

    test(
        'should throw an [APIException] when the status code is not 200 or 201',
        () async {
      // arrange
      when(
        () => client.post(
          any(),
          body: any(named: 'body'),
        ),
      ).thenAnswer(
        (_) async => http.Response('User not created', 400),
      );

      // act
      final methodCall = remoteDataSource.createUser;

      // assert
      expect(
        () async => methodCall(
          createdAt: 'createdAt',
          name: 'name',
          avatar: 'avatar',
        ),
        throwsA(
            const APIException(message: 'User not created', statusCode: 400)),
      );

      verify(
        () => client.post(
          Uri.https(cBaseUrl, cCreateUserEndpoint),
          body: {
            'createdAt': 'createdAt',
            'name': 'name',
            'avatar': 'avatar',
          },
        ),
      ).called(1);

      verifyNoMoreInteractions(client);
    });
  });

  group('getUsers', () {
    const cUsers = [UserModel.empty()];
    test('should return [List<UserModel>] when the status code is 200',
        () async {
      // arrange
      when(() => client.get(any())).thenAnswer(
          (_) async => http.Response(jsonEncode([cUsers.first.toMap()]), 200));

      // act
      final result = await remoteDataSource.getUsers();

      // assert
      expect(result, equals(cUsers));
      verify(() => client.get(Uri.https(cBaseUrl, cGetUsersEndpoint)))
          .called(1);
      verifyNoMoreInteractions(client);
    });

    test('should throw an [APIException] when the status code is not 200',
        () async {
      // arrange
      when(() => client.get(any()))
          .thenAnswer((_) async => http.Response('Server down', 500));

      // act
      final methodCall = remoteDataSource.getUsers;

      // assert
      expect(
        () async => methodCall(),
        throwsA(const APIException(message: 'Server down', statusCode: 500)),
      );

      verify(() => client.get(Uri.https(cBaseUrl, cGetUsersEndpoint))).called(1);
      verifyNoMoreInteractions(client);
    });
  });
}

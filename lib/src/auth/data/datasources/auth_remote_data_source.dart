import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:hyper_authen_app/core/errors/exceptions.dart';
import 'package:hyper_authen_app/core/utils/constants.dart';
import 'package:hyper_authen_app/core/utils/typedef.dart';
import 'package:hyper_authen_app/src/auth/data/models/user_model.dart';

abstract class AuthenticationRemoteDataSource {
  Future<void> createUser({
    required String createdAt,
    required String name,
    required String avatar,
  });

  Future<List<UserModel>> getUsers();
}

const cCreateUserEndpoint = '/test-api/users';

const cGetUsersEndpoint = '/test-api/user';

class AuthenticationRemoteDataSourceImplementation
    implements AuthenticationRemoteDataSource {
  const AuthenticationRemoteDataSourceImplementation(this._client);

  final http.Client _client;

  @override
  Future<void> createUser(
      {required String createdAt,
      required String name,
      required String avatar}) async {
    // 1. Check to make sure that the ít return the right data when the response
    // code is 200 or the proper response code
    // 2. Check to make sure that it "THROWS A CUSTOM EXCEPTION" with the right
    // message when status code is bad one

    try {
      final response = await _client.post(
        Uri.https(cBaseUrl, cCreateUserEndpoint),
        body: {
          'createdAt': createdAt,
          'name': name,
          'avatar': avatar,
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw APIException(
          message: response.body,
          statusCode: response.statusCode,
        );
      }
    } on APIException {
      rethrow;
    }
    catch (e) {
      throw APIException(
        message: e.toString(),
        statusCode: 505,
      );
    }
  }

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final response = await _client.get(Uri.https(cBaseUrl, cGetUsersEndpoint));
      if (response.statusCode != 200) {
        throw APIException(
          message: response.body,
          statusCode: response.statusCode,
        );
      }

      return List<DataMap>.from(jsonDecode(response.body) as List)
          .map((userData) => UserModel.fromMap(userData))
          .toList();
    }
    on APIException {
      rethrow;
    }
    catch (e) {
      throw APIException(
        message: e.toString(),
        statusCode: 505,
      );
    }
  }
}

import 'package:dartz/dartz.dart';
import 'package:hyper_authen_app/core/errors/exceptions.dart';
import 'package:hyper_authen_app/core/errors/failure.dart';
import 'package:hyper_authen_app/core/utils/typedef.dart';
import 'package:hyper_authen_app/src/auth/data/datasources/auth_remote_data_source.dart';
import 'package:hyper_authen_app/src/auth/domain/entities/user.dart';
import 'package:hyper_authen_app/src/auth/domain/repos/auth_repo.dart';

class AuthenticationRepositoryImplementation
    implements AuthenticationRepository {
  const AuthenticationRepositoryImplementation(this._remoteDataSource);

  final AuthenticationRemoteDataSource _remoteDataSource;

  @override
  ResultVoid createUser(
      {required String createdAt,
      required String name,
      required String avatar}) async {
    // Test-Driven Development
    // Call the remote data source to create a user
    // Check if the method returns the proper data
    // Make sure that it returns the proper data if there is no exception
    // Check if when the RemoteDataSource throws an exception, we return a
    // failure

    try {
      await _remoteDataSource.createUser(
        createdAt: createdAt,
        name: name,
        avatar: avatar,
      );
      return const Right(null);
    } on APIException catch (e){
      //return Left(APIFailure(message: e.message, statusCode: e.statusCode));
      return Left(APIFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<User>> getUsers() async {
    try {
      final users = await _remoteDataSource.getUsers();
      return Right(users);
    } on APIException catch (e) {
      return Left(APIFailure.fromException(e));
    }

  }
}

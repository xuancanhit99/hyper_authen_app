import 'package:dartz/dartz.dart';
import 'package:hyper_authen_app/core/errors/failure.dart';
import 'package:hyper_authen_app/core/utils/typedef.dart';
import 'package:hyper_authen_app/src/auth/domain/entities/user.dart';

abstract class AuthenticationRepository {
  const AuthenticationRepository();

  ResultVoid createUser(
      {required String createdAt,
      required String name,
      required String avatar,});

  ResultFuture<List<User>> getUsers();


}

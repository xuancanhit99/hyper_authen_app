import 'package:hyper_authen_app/core/usecase/usecase.dart';
import 'package:hyper_authen_app/core/utils/typedef.dart';
import 'package:hyper_authen_app/src/auth/domain/entities/user.dart';
import 'package:hyper_authen_app/src/auth/domain/repos/auth_repo.dart';

class GetUsers extends UseCaseWithoutParams<List<User>> {
  GetUsers(this._repository);

  final AuthenticationRepository _repository;

  @override
  ResultFuture<List<User>> call() async => _repository.getUsers();
}

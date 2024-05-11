import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyper_authen_app/src/auth/domain/entities/user.dart';
import 'package:hyper_authen_app/src/auth/domain/repos/auth_repo.dart';
import 'package:hyper_authen_app/src/auth/domain/usecases/get_users.dart';
import 'package:mocktail/mocktail.dart';

import 'authentication_repository.mock.dart';

void main() {
  late AuthenticationRepository repository;
  late GetUsers useCase;

  setUp(() {
    repository = MockAuthRepo();
    useCase = GetUsers(repository);
  });

  const cResponse = [User.empty()];

  test(
    'should call the [AuthRepo.getUsers] and return [List<User>]',
    () async {
      // Arrange
      // Stubbing
      when(() => repository.getUsers())
          .thenAnswer((_) async => const Right(cResponse));

      // Act
      final result = await useCase();

      // Assert
      expect(result, equals(const Right<dynamic, List<User>>(cResponse)));
      verify(() => repository.getUsers()).called(1);

      verifyNoMoreInteractions(repository);
    },
  );
}

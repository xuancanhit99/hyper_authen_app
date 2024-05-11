import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyper_authen_app/core/errors/exceptions.dart';
import 'package:hyper_authen_app/core/errors/failure.dart';
import 'package:hyper_authen_app/src/auth/data/datasources/auth_remote_data_source.dart';
import 'package:hyper_authen_app/src/auth/data/repos/auth_repo_impl.dart';
import 'package:hyper_authen_app/src/auth/domain/entities/user.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDataSrc extends Mock
    implements AuthenticationRemoteDataSource {}

void main() {
  late AuthenticationRemoteDataSource remoteDataSource;
  late AuthenticationRepositoryImplementation repoImpl;

  setUp(() {
    remoteDataSource = MockAuthRemoteDataSrc();
    repoImpl = AuthenticationRepositoryImplementation(remoteDataSource);
  });

  const cException = APIException(
    message: 'Unknown Error Occurred',
    statusCode: 500,
  );

  group('createUser', () {
    const createdAt = 'whatever.createdAt';
    const name = 'whatever.name';
    const avatar = 'whatever.avatar';

    test(
        'should call the [RemoteDataSource.createUser] and complete '
        'successfully when the call to the remote source is successful',
        () async {
      // arrange
      when(
        () => remoteDataSource.createUser(
          createdAt: any(named: 'createdAt'),
          name: any(named: 'name'),
          avatar: any(named: 'avatar'),
        ),
      ).thenAnswer(
        (_) async => Future.value(),
      ); // Always return a successful future (void-createUser)

      // act
      final result = await repoImpl.createUser(
        createdAt: createdAt,
        name: name,
        avatar: avatar,
      );

      // assert
      expect(result, equals(const Right(null)));
      verify(
        () => remoteDataSource.createUser(
          createdAt: createdAt,
          name: name,
          avatar: avatar,
        ),
      ).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test(
        'should return a [APIFailure] when the call to remote source '
        'is unsuccessful', () async {
      // arrange
      when(
        () => remoteDataSource.createUser(
          createdAt: any(named: 'createdAt'),
          name: any(named: 'name'),
          avatar: any(named: 'avatar'),
        ),
      ).thenThrow(
        cException,
      );

      // act
      final result = await repoImpl.createUser(
        createdAt: createdAt,
        name: name,
        avatar: avatar,
      );

      // assert
      expect(
        result,
        equals(
          Left(
            APIFailure(
              message: cException.message,
              statusCode: cException.statusCode,
            ),
          ),
        ),
      );

      verify(
        () => remoteDataSource.createUser(
          createdAt: createdAt,
          name: name,
          avatar: avatar,
        ),
      ).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });

  group('getUser', () {
    test(
        'should call the [RemoteDataSource.getUsers] and return [List<User>] '
        'when call to remote source is successful', () async {
      // arrange
      when(() => remoteDataSource.getUsers()).thenAnswer((_) async => []);

      // act
      final result = await repoImpl.getUsers();

      // assert
      expect(result, isA<Right<dynamic, List<User>>>());
      verify(() => remoteDataSource.getUsers()).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test(
      'should return a [APIFailure] when the call to remote source '
      'is unsuccessful',
      () async {
        // arrange
        when(() => remoteDataSource.getUsers()).thenThrow(cException);

        // act
        final result = await repoImpl.getUsers();

        // assert
        expect(
          result,
          equals(
            Left(
              APIFailure.fromException(cException),
            ),
          ),
        );
        verify(() => remoteDataSource.getUsers()).called(1);
        verifyNoMoreInteractions(remoteDataSource);


        },
    );
  });
}

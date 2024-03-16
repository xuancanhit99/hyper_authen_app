import 'package:dartz/dartz.dart';
import 'package:hyper_authen_app/core/errors/failure.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;

typedef ResultVoid = Future<Either<Failure, void>>;

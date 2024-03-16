import 'package:hyper_authen_app/core/utils/typedef.dart';

abstract class UseCaseWithParams<Type, Params> {
  UseCaseWithParams();
  ResultFuture<Type> call(Params params);
}

abstract class UseCaseWithoutParams<Type> {
  UseCaseWithoutParams();
  ResultFuture<Type> call();
}
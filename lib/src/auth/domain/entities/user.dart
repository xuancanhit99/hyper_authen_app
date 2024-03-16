

import 'package:equatable/equatable.dart';

class User extends Equatable {

  const User({
    required this.id,
    required this.createAt,
    required this.name,
    required this.avatar,
  });

  final String id;
  final String createAt;
  final String name;
  final String avatar;

  @override

  List<Object?> get props => [id];
}
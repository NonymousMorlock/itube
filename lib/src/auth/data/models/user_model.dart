import 'dart:convert';

import 'package:itube/core/typedefs.dart';
import 'package:itube/src/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.emailVerified,
    required super.cognitoSub,
  });

  const UserModel.empty()
    : this(
        id: 'Test String',
        email: 'Test String',
        name: 'Test String',
        emailVerified: true,
        cognitoSub: 'Test String',
      );

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(jsonDecode(source) as DataMap);

  UserModel.fromMap(DataMap map)
    : this(
        id: map['id'] as String,
        email: map['email'] as String,
        name: map['name'] as String,
        emailVerified: map['email_verified'] as bool,
        cognitoSub: map['cognito_sub'] as String,
      );

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    bool? emailVerified,
    String? cognitoSub,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      emailVerified: emailVerified ?? this.emailVerified,
      cognitoSub: cognitoSub ?? this.cognitoSub,
    );
  }

  DataMap toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'name': name,
      'email_verified': emailVerified,
      'cognito_sub': cognitoSub,
    };
  }

  String toJson() => jsonEncode(toMap());
}

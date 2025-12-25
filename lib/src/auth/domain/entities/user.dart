import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.emailVerified,
    required this.cognitoSub,
  });

  const User.empty()
    : this(
        id: 'Test String',
        email: 'Test String',
        name: 'Test String',
        emailVerified: true,
        cognitoSub: 'Test String',
      );

  final String id;

  final String email;

  final String name;

  final bool emailVerified;

  final String cognitoSub;

  @override
  List<Object?> get props => [id, email, name, emailVerified, cognitoSub];
}

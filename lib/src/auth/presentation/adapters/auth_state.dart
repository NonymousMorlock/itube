part of 'auth_adapter.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class FetchingPendingRegistrationEmail extends AuthLoading {
  const FetchingPendingRegistrationEmail();
}

final class CurrentUserLoaded extends AuthState {
  const CurrentUserLoaded({required this.user});

  final User user;

  @override
  List<Object?> get props => [user];
}

final class PendingRegistrationEmailLoaded extends AuthState {
  const PendingRegistrationEmailLoaded({required this.email});

  final String? email;

  @override
  List<Object?> get props => [email];
}

final class LoggedIn extends AuthState {
  const LoggedIn();
}

final class LoggedOut extends AuthState {
  const LoggedOut();
}

final class Registered extends AuthState {
  const Registered();
}

final class EmailVerified extends AuthState {
  const EmailVerified();
}

final class AuthError extends AuthState {
  const AuthError({required this.message, required this.title});

  AuthError.fromFailure(Failure failure)
    : this(
        message: failure.message,
        title:
            '${failure.statusCode is int ? 'Error ' : ''}'
            '${failure.statusCode}',
      );

  final String message;

  final String? title;

  @override
  List<Object?> get props => [message, title];
}

final class PendingRegistrationEmailError extends AuthError {
  const PendingRegistrationEmailError({required super.message, super.title});

  PendingRegistrationEmailError.fromFailure(Failure failure)
    : this(
        message: failure.message,
        title:
            '${failure.statusCode is int ? 'Error ' : ''}'
            '${failure.statusCode}',
      );
}

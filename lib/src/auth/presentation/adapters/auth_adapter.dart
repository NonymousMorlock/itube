import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:itube/app/providers/current_user_provider.dart';
import 'package:itube/core/errors/failures.dart';
import 'package:itube/src/auth/domain/entities/user.dart';
import 'package:itube/src/auth/domain/usecases/get_current_user.dart';
import 'package:itube/src/auth/domain/usecases/get_pending_registration_email.dart';
import 'package:itube/src/auth/domain/usecases/login.dart';
import 'package:itube/src/auth/domain/usecases/logout.dart';
import 'package:itube/src/auth/domain/usecases/register.dart';
import 'package:itube/src/auth/domain/usecases/verify_email.dart';

part 'auth_state.dart';

class AuthAdapter extends Cubit<AuthState> {
  AuthAdapter({
    required CurrentUserProvider currentUserProvider,
    required GetCurrentUser getCurrentUser,
    required GetPendingRegistrationEmail getPendingRegistrationEmail,
    required Login login,
    required Logout logout,
    required Register register,
    required VerifyEmail verifyEmail,
  }) : _currentUserProvider = currentUserProvider,
       _getCurrentUser = getCurrentUser,
       _getPendingRegistrationEmail = getPendingRegistrationEmail,
       _login = login,
       _logout = logout,
       _register = register,
       _verifyEmail = verifyEmail,
       super(const AuthInitial());

  final CurrentUserProvider _currentUserProvider;

  final GetCurrentUser _getCurrentUser;

  final GetPendingRegistrationEmail _getPendingRegistrationEmail;

  final Login _login;

  final Logout _logout;

  final Register _register;

  final VerifyEmail _verifyEmail;

  Future<void> getCurrentUser() async {
    emit(const AuthLoading());
    final result = await _getCurrentUser();
    result.fold(
      (failure) => emit(AuthError.fromFailure(failure)),
      (user) {
        _currentUserProvider.setUser(user);
        emit(CurrentUserLoaded(user: user));
      },
    );
  }

  Future<void> getPendingRegistrationEmail() async {
    emit(const FetchingPendingRegistrationEmail());
    final result = await _getPendingRegistrationEmail();
    result.fold(
      (failure) => emit(PendingRegistrationEmailError.fromFailure(failure)),
      (email) => emit(PendingRegistrationEmailLoaded(email: email)),
    );
  }

  Future<void> login({required String email, required String password}) async {
    emit(const AuthLoading());
    final result = await _login(LoginParams(email: email, password: password));
    result.fold(
      (failure) => emit(AuthError.fromFailure(failure)),
      (_) => emit(const LoggedIn()),
    );
  }

  Future<void> logout() async {
    emit(const AuthLoading());
    final result = await _logout();
    result.fold(
      (failure) => emit(AuthError.fromFailure(failure)),
      (_) {
        _currentUserProvider.clearUser();
        emit(const LoggedOut());
      },
    );
  }

  Future<void> register({
    required String email,
    required String name,
    required String password,
  }) async {
    emit(const AuthLoading());
    final result = await _register(
      RegisterParams(email: email, name: name, password: password),
    );
    result.fold(
      (failure) => emit(AuthError.fromFailure(failure)),
      (_) => emit(const Registered()),
    );
  }

  Future<void> verifyEmail({required String email, required String otp}) async {
    emit(const AuthLoading());
    final result = await _verifyEmail(
      VerifyEmailParams(email: email, otp: otp),
    );
    result.fold(
      (failure) => emit(AuthError.fromFailure(failure)),
      (_) => emit(const EmailVerified()),
    );
  }

  @override
  void emit(AuthState state) {
    if (isClosed) return;
    super.emit(state);
  }
}

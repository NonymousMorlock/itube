import 'package:itube/src/auth/domain/entities/user.dart';

final class CurrentUserProvider {
  CurrentUserProvider._();

  static final CurrentUserProvider instance = CurrentUserProvider._();

  User? _user;

  User? get user => _user;

  bool get userExists => _user != null;

  void setUser(User user) {
    if (_user != user) _user = user;
  }

  void clearUser() {
    _user = null;
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/auth_state.dart';

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState(
      isAuthenticated: false,
      email: null,
      role: UserRole.admin,
    );
  }

  void login({required String email, required UserRole role}) {
    state = state.copyWith(
      isAuthenticated: true,
      email: email,
      role: role,
    );
  }

  void setRole(UserRole role) {
    state = state.copyWith(role: role);
  }

  void logout() {
    state = const AuthState(
      isAuthenticated: false,
      email: null,
      role: UserRole.admin,
    );
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(AuthController.new);

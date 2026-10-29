enum UserRole {
  admin('Administrador Municipal'),
  inspector('Inspector'),
  worker('Desmalezador'),
  neighborhoodLeader('Responsable Vecinal'),
  neighbor('Vecino');

  final String label;
  const UserRole(this.label);

  static UserRole fromLabel(String label) {
    return UserRole.values.firstWhere(
      (r) => r.label == label,
      orElse: () => UserRole.worker,
    );
  }
}

class AuthState {
  final bool isAuthenticated;
  final String? email;
  final UserRole role;

  const AuthState({
    this.isAuthenticated = false,
    this.email,
    this.role = UserRole.admin,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? email,
    UserRole? role,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      email: email ?? this.email,
      role: role ?? this.role,
    );
  }
}

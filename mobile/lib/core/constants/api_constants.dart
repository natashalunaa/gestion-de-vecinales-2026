class ApiConstants {
  // Ajustar según el entorno (localhost para emulador Android es 10.0.2.2)
  static const String baseUrl = 'http://10.0.2.2:8080/api';

  // Endpoints
  static const String workers = '$baseUrl/workers';
  static const String greenSpaces = '$baseUrl/green-spaces';
  static const String jobs = '$baseUrl/jobs';
  static const String authLogin = '$baseUrl/auth/login';
}

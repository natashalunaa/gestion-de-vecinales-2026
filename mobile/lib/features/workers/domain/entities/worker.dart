enum WorkerStatus {
  habilitado,
  pendienteHabilitacion,
  inhabilitado,
}

class InsuranceEntity {
  final String policyNumber;
  final String insurerName;
  final DateTime expiresAt;

  const InsuranceEntity({
    required this.policyNumber,
    required this.insurerName,
    required this.expiresAt,
  });

  bool get isValid => DateTime.now().isBefore(expiresAt);
}

class WorkerEntity {
  final String id;
  final String dni;
  final String firstName;
  final String lastName;
  final String phone;
  final WorkerStatus status;
  final InsuranceEntity? insurance;

  const WorkerEntity({
    required this.id,
    required this.dni,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.status,
    this.insurance,
  });

  String get fullName => '$firstName $lastName';
}

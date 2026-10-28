import '../../domain/entities/worker.dart';

class WorkerModel extends WorkerEntity {
  const WorkerModel({
    required super.id,
    required super.dni,
    required super.firstName,
    required super.lastName,
    required super.phone,
    required super.status,
    super.insurance,
  });

  factory WorkerModel.fromJson(Map<String, dynamic> json) {
    WorkerStatus parseStatus(String? statusStr) {
      switch (statusStr) {
        case 'HABILITADO':
          return WorkerStatus.habilitado;
        case 'INHABILITADO':
          return WorkerStatus.inhabilitado;
        default:
          return WorkerStatus.pendienteHabilitacion;
      }
    }

    InsuranceEntity? parseInsurance(Map<String, dynamic>? insJson) {
      if (insJson == null) return null;
      return InsuranceEntity(
        policyNumber: insJson['policy_number'] ?? '',
        insurerName: insJson['insurer_name'] ?? '',
        expiresAt: DateTime.tryParse(insJson['expires_at'] ?? '') ?? DateTime.now(),
      );
    }

    return WorkerModel(
      id: json['id'] ?? '',
      dni: json['dni'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      phone: json['phone'] ?? '',
      status: parseStatus(json['status']),
      insurance: parseInsurance(json['insurance']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dni': dni,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'status': status.name.toUpperCase(),
      if (insurance != null)
        'insurance': {
          'policy_number': insurance!.policyNumber,
          'insurer_name': insurance!.insurerName,
          'expires_at': insurance!.expiresAt.toIso8601String(),
        },
    };
  }
}

import '../../domain/entities/worker.dart';
import '../../domain/repositories/worker_repository.dart';

class MockWorkerRepository implements WorkerRepository {
  final List<WorkerEntity> _workers = [
    WorkerEntity(
      id: 'w-1',
      dni: '35123456',
      firstName: 'Carlos',
      lastName: 'Gómez',
      phone: '358-4567890',
      status: WorkerStatus.habilitado,
      insurance: InsuranceEntity(
        policyNumber: 'SEG-2026-001',
        insurerName: 'Rivadavia Seguros',
        expiresAt: DateTime.now().add(const Duration(days: 45)),
      ),
    ),
    WorkerEntity(
      id: 'w-2',
      dni: '40987654',
      firstName: 'Marcos',
      lastName: 'López',
      phone: '358-4112233',
      status: WorkerStatus.pendienteHabilitacion,
      insurance: InsuranceEntity(
        policyNumber: 'SEG-2025-999',
        insurerName: 'Sancor Seguros',
        expiresAt: DateTime.now().subtract(const Duration(days: 3)), // Vencido
      ),
    ),
  ];

  @override
  Future<List<WorkerEntity>> getWorkers() async {
    // Simula latencia de red para ilustrar el AsyncValue de Riverpod
    await Future.delayed(const Duration(milliseconds: 500));
    return List.unmodifiable(_workers);
  }

  @override
  Future<WorkerEntity> registerWorker({
    required String dni,
    required String firstName,
    required String lastName,
    required String phone,
    String? policyNumber,
    String? insurerName,
    DateTime? expiresAt,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));

    InsuranceEntity? insurance;
    WorkerStatus status = WorkerStatus.pendienteHabilitacion;

    if (policyNumber != null &&
        insurerName != null &&
        expiresAt != null &&
        policyNumber.isNotEmpty &&
        insurerName.isNotEmpty) {
      insurance = InsuranceEntity(
        policyNumber: policyNumber,
        insurerName: insurerName,
        expiresAt: expiresAt,
      );
      if (insurance.isValid) {
        status = WorkerStatus.habilitado;
      }
    }

    final newWorker = WorkerEntity(
      id: 'w-${DateTime.now().millisecondsSinceEpoch}',
      dni: dni,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      status: status,
      insurance: insurance,
    );

    _workers.add(newWorker);
    return newWorker;
  }
}

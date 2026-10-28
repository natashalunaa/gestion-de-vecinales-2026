import '../entities/worker.dart';

abstract class WorkerRepository {
  Future<List<WorkerEntity>> getWorkers();
  Future<WorkerEntity> registerWorker({
    required String dni,
    required String firstName,
    required String lastName,
    required String phone,
    String? policyNumber,
    String? insurerName,
    DateTime? expiresAt,
  });
}

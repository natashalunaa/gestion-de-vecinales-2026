import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/worker.dart';
import '../../domain/repositories/worker_repository.dart';
import '../../data/repositories/mock_worker_repository.dart';

// Provider del repositorio (Inyección de dependencias con Riverpod)
final workerRepositoryProvider = Provider<WorkerRepository>((ref) {
  return MockWorkerRepository();
});

// AsyncNotifier para gestionar el ciclo de vida (Loading, Error, Data)
class WorkersController extends AsyncNotifier<List<WorkerEntity>> {
  @override
  FutureOr<List<WorkerEntity>> build() async {
    final repository = ref.watch(workerRepositoryProvider);
    return repository.getWorkers();
  }

  Future<void> addWorker({
    required String dni,
    required String firstName,
    required String lastName,
    required String phone,
    String? policyNumber,
    String? insurerName,
    DateTime? expiresAt,
  }) async {
    final repository = ref.read(workerRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final newWorker = await repository.registerWorker(
        dni: dni,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        policyNumber: policyNumber,
        insurerName: insurerName,
        expiresAt: expiresAt,
      );
      final currentList = state.valueOrNull ?? [];
      return [...currentList, newWorker];
    });
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return ref.read(workerRepositoryProvider).getWorkers();
    });
  }
}

final workersControllerProvider =
    AsyncNotifierProvider<WorkersController, List<WorkerEntity>>(WorkersController.new);

// Providers derivados (selectores reactivos para estadísticas de la nómina)
final enabledWorkersCountProvider = Provider<int>((ref) {
  final workersAsync = ref.watch(workersControllerProvider);
  return workersAsync.maybeWhen(
    data: (workers) => workers.where((w) => w.status == WorkerStatus.habilitado).length,
    orElse: () => 0,
  );
});

final pendingWorkersCountProvider = Provider<int>((ref) {
  final workersAsync = ref.watch(workersControllerProvider);
  return workersAsync.maybeWhen(
    data: (workers) => workers.where((w) => w.status == WorkerStatus.pendienteHabilitacion).length,
    orElse: () => 0,
  );
});

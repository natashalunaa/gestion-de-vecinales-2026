import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/worker.dart';
import '../../../../core/theme/app_theme.dart';
import '../controllers/workers_controller.dart';
import 'worker_form_screen.dart';

class WorkersListScreen extends ConsumerWidget {
  const WorkersListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workersAsync = ref.watch(workersControllerProvider);
    final enabledCount = ref.watch(enabledWorkersCountProvider);
    final pendingCount = ref.watch(pendingWorkersCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Desmalezadores'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Sincronizar nómina',
            onPressed: () => ref.read(workersControllerProvider.notifier).refresh(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de resumen reactivo con Riverpod
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: Colors.grey.shade100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  avatar: const CircleAvatar(
                    backgroundColor: AppTheme.statusGreen,
                    radius: 6,
                  ),
                  label: Text('Habilitados: $enabledCount', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ),
                Chip(
                  avatar: const CircleAvatar(
                    backgroundColor: AppTheme.statusYellow,
                    radius: 6,
                  ),
                  label: Text('Pendientes: $pendingCount', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ],
            ),
          ),
          // Lista reactiva con manejo de estados Asíncronos
          Expanded(
            child: workersAsync.when(
              loading: () => const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 12),
                    Text('Cargando desmalezadores con Riverpod...'),
                  ],
                ),
              ),
              error: (err, stack) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 48),
                    const SizedBox(height: 8),
                    Text('Error: $err', style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => ref.read(workersControllerProvider.notifier).refresh(),
                      child: const Text('Reintentar'),
                    )
                  ],
                ),
              ),
              data: (workers) {
                if (workers.isEmpty) {
                  return const Center(
                    child: Text('No hay desmalezadores registrados aún.'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: workers.length,
                  itemBuilder: (context, index) {
                    final worker = workers[index];
                    final isHabilitado = worker.status == WorkerStatus.habilitado;

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: CircleAvatar(
                          backgroundColor: isHabilitado ? AppTheme.statusGreen : AppTheme.statusYellow,
                          child: Icon(
                            isHabilitado ? Icons.check : Icons.warning_amber_rounded,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          worker.fullName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text('DNI: ${worker.dni} | Tel: ${worker.phone}'),
                            const SizedBox(height: 2),
                            Text(
                              worker.insurance != null
                                  ? 'Seguro: ${worker.insurance!.insurerName} (${worker.insurance!.isValid ? "Al día" : "Vencido"})'
                                  : 'Sin seguro cargado',
                              style: TextStyle(
                                color: worker.insurance?.isValid == true ? Colors.green.shade800 : Colors.red.shade800,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        trailing: Chip(
                          label: Text(
                            isHabilitado ? 'Habilitado' : 'Pendiente',
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          backgroundColor: isHabilitado ? AppTheme.statusGreen : AppTheme.statusYellow,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.primary,
        icon: const Icon(Icons.person_add, color: Colors.white),
        label: const Text('Nuevo Desmalezador', style: TextStyle(color: Colors.white)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const WorkerFormScreen(),
            ),
          );
        },
      ),
    );
  }
}

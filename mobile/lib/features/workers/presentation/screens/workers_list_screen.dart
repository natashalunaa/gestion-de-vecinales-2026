import 'package:flutter/material.dart';
import '../../domain/entities/worker.dart';
import '../../../../core/theme/app_theme.dart';
import 'worker_form_screen.dart';

class WorkersListScreen extends StatefulWidget {
  const WorkersListScreen({super.key});

  @override
  State<WorkersListScreen> createState() => _WorkersListScreenState();
}

class _WorkersListScreenState extends State<WorkersListScreen> {
  // Datos simulados iniciales para desarrollo ágil e interactivo
  final List<WorkerEntity> _mockWorkers = [
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Desmalezadores'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sincronizando con backend...')),
              );
            },
          )
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _mockWorkers.length,
        itemBuilder: (context, index) {
          final worker = _mockWorkers[index];
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.primary,
        icon: const Icon(Icons.person_add, color: Colors.white),
        label: const Text('Nuevo Desmalezador', style: TextStyle(color: Colors.white)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WorkerFormScreen(
                onWorkerAdded: (newWorker) {
                  setState(() {
                    _mockWorkers.add(newWorker);
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

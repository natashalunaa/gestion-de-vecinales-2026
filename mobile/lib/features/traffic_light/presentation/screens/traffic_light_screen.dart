import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/green_space_entity.dart';
import '../controllers/traffic_light_controller.dart';

class TrafficLightScreen extends ConsumerWidget {
  const TrafficLightScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredSpaces = ref.watch(filteredGreenSpacesProvider);
    final selectedFilter = ref.watch(selectedTrafficFilterProvider);
    final counts = ref.watch(trafficSummaryCountsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Semáforo de Espacios Verdes'),
      ),
      body: Column(
        children: [
          // Barra de filtros semafóricos con Riverpod
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Colors.green.shade50,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ChoiceChip(
                    label: Text('Todos (${counts.green + counts.yellow + counts.red})'),
                    selected: selectedFilter == null,
                    onSelected: (_) => ref.read(selectedTrafficFilterProvider.notifier).state = null,
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    avatar: const CircleAvatar(backgroundColor: AppTheme.statusGreen, radius: 5),
                    label: Text('Verde (${counts.green})'),
                    selected: selectedFilter == TrafficStatus.green,
                    onSelected: (_) => ref.read(selectedTrafficFilterProvider.notifier).state = TrafficStatus.green,
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    avatar: const CircleAvatar(backgroundColor: AppTheme.statusYellow, radius: 5),
                    label: Text('Amarillo (${counts.yellow})'),
                    selected: selectedFilter == TrafficStatus.yellow,
                    onSelected: (_) => ref.read(selectedTrafficFilterProvider.notifier).state = TrafficStatus.yellow,
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    avatar: const CircleAvatar(backgroundColor: AppTheme.statusRed, radius: 5),
                    label: Text('Rojo (${counts.red})'),
                    selected: selectedFilter == TrafficStatus.red,
                    onSelected: (_) => ref.read(selectedTrafficFilterProvider.notifier).state = TrafficStatus.red,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: filteredSpaces.isEmpty
                ? const Center(child: Text('No hay espacios verdes en este estado.'))
                : ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: filteredSpaces.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final space = filteredSpaces[index];
                      final Color statusColor = space.status.color;

                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: statusColor.withValues(alpha: 0.6), width: 1.5),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: statusColor,
                            child: const Icon(Icons.park, color: Colors.white),
                          ),
                          title: Text(
                            space.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('Barrio: ${space.neighborhood} (${space.type})\nÚltimo corte: hace ${space.daysSinceLastCut} días'),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Chip(
                                backgroundColor: statusColor,
                                label: Text(
                                  space.status.label,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                                ),
                              ),
                            ],
                          ),
                          isThreeLine: true,
                          onTap: () {
                            // Acción rápida: simular registro de desmalezado (reinicia semáforo a verde)
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text(space.name),
                                content: Text('¿Deseas simular la validación de un corte de césped para reiniciar su semáforo a VERDE?'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
                                  ElevatedButton(
                                    onPressed: () {
                                      ref.read(trafficLightControllerProvider.notifier).markCutCompleted(space.id);
                                      Navigator.pop(ctx);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('¡${space.name} ahora está en VERDE!'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    },
                                    child: const Text('Validar Corte'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

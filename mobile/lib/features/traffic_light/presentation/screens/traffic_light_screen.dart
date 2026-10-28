import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class TrafficLightScreen extends StatelessWidget {
  const TrafficLightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> mockSpaces = [
      {
        'name': 'Plaza Roca',
        'barrio': 'Centro',
        'tipo': 'Plaza',
        'dias': 4,
        'estado': 'VERDE',
        'color': AppTheme.statusGreen,
      },
      {
        'name': 'Plaza Olmos',
        'barrio': 'Banda Norte',
        'tipo': 'Plaza',
        'dias': 11,
        'estado': 'AMARILLO',
        'color': AppTheme.statusYellow,
      },
      {
        'name': 'Veredas y Ochavas Río Limay',
        'barrio': 'Alberdi',
        'tipo': 'Vereda / Ochava',
        'dias': 25,
        'estado': 'ROJO',
        'color': AppTheme.statusRed,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Semáforo de Espacios Verdes'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.green.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLegendItem('Óptimo (<10d)', AppTheme.statusGreen),
                _buildLegendItem('Atención (10-15d)', AppTheme.statusYellow),
                _buildLegendItem('Urgente (>15d)', AppTheme.statusRed),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: mockSpaces.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final space = mockSpaces[index];
                final Color statusColor = space['color'] as Color;

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
                      space['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Barrio: ${space['barrio']} • Último corte: hace ${space['dias']} días'),
                    trailing: Chip(
                      backgroundColor: statusColor,
                      label: Text(
                        space['estado'],
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

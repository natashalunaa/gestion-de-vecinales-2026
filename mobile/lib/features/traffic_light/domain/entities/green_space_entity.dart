import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

enum TrafficStatus {
  green('VERDE', AppTheme.statusGreen),
  yellow('AMARILLO', AppTheme.statusYellow),
  red('ROJO', AppTheme.statusRed);

  final String label;
  final Color color;
  const TrafficStatus(this.label, this.color);
}

class GreenSpaceEntity {
  final String id;
  final String name;
  final String neighborhood;
  final String type; // 'Plaza', 'Vereda', 'Ochava'
  final int daysSinceLastCut;
  final TrafficStatus status;

  const GreenSpaceEntity({
    required this.id,
    required this.name,
    required this.neighborhood,
    required this.type,
    required this.daysSinceLastCut,
    required this.status,
  });

  static TrafficStatus calculateStatus(String type, int days) {
    if (type.toLowerCase().contains('plaza')) {
      if (days <= 7) return TrafficStatus.green;
      if (days <= 12) return TrafficStatus.yellow;
      return TrafficStatus.red;
    } else {
      if (days <= 20) return TrafficStatus.green;
      if (days <= 30) return TrafficStatus.yellow;
      return TrafficStatus.red;
    }
  }
}

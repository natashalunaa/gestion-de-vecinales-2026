import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/green_space_entity.dart';

// Lista inicial de espacios verdes municipales
class TrafficLightController extends Notifier<List<GreenSpaceEntity>> {
  @override
  List<GreenSpaceEntity> build() {
    return [
      const GreenSpaceEntity(
        id: 'gs-1',
        name: 'Plaza Roca',
        neighborhood: 'Centro',
        type: 'Plaza',
        daysSinceLastCut: 4,
        status: TrafficStatus.green,
      ),
      const GreenSpaceEntity(
        id: 'gs-2',
        name: 'Plaza Olmos de Aguilera',
        neighborhood: 'Banda Norte',
        type: 'Plaza',
        daysSinceLastCut: 11,
        status: TrafficStatus.yellow,
      ),
      const GreenSpaceEntity(
        id: 'gs-3',
        name: 'Veredas y Ochavas Río Limay',
        neighborhood: 'Alberdi',
        type: 'Vereda / Ochava',
        daysSinceLastCut: 25,
        status: TrafficStatus.red,
      ),
      const GreenSpaceEntity(
        id: 'gs-4',
        name: 'Parque Sarmiento',
        neighborhood: 'Banda Norte',
        type: 'Plaza',
        daysSinceLastCut: 15,
        status: TrafficStatus.red,
      ),
      const GreenSpaceEntity(
        id: 'gs-5',
        name: 'Plaza Mójica',
        neighborhood: 'Castelli',
        type: 'Plaza',
        daysSinceLastCut: 6,
        status: TrafficStatus.green,
      ),
    ];
  }

  void markCutCompleted(String spaceId) {
    state = [
      for (final s in state)
        if (s.id == spaceId)
          GreenSpaceEntity(
            id: s.id,
            name: s.name,
            neighborhood: s.neighborhood,
            type: s.type,
            daysSinceLastCut: 0,
            status: TrafficStatus.green,
          )
        else
          s,
    ];
  }
}

final trafficLightControllerProvider =
    NotifierProvider<TrafficLightController, List<GreenSpaceEntity>>(TrafficLightController.new);

// Filtro seleccionado (null = Todos, o un TrafficStatus específico)
final selectedTrafficFilterProvider = StateProvider<TrafficStatus?>((ref) => null);

// Lista filtrada reactiva (Selector derivado)
final filteredGreenSpacesProvider = Provider<List<GreenSpaceEntity>>((ref) {
  final spaces = ref.watch(trafficLightControllerProvider);
  final filter = ref.watch(selectedTrafficFilterProvider);

  if (filter == null) return spaces;
  return spaces.where((s) => s.status == filter).toList();
});

// Resumen de conteos
final trafficSummaryCountsProvider = Provider<({int green, int yellow, int red})>((ref) {
  final spaces = ref.watch(trafficLightControllerProvider);
  return (
    green: spaces.where((s) => s.status == TrafficStatus.green).length,
    yellow: spaces.where((s) => s.status == TrafficStatus.yellow).length,
    red: spaces.where((s) => s.status == TrafficStatus.red).length,
  );
});

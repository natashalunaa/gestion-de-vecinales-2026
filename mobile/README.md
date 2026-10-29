# App Móvil - Sistema de Gestión y Control de Desmalezado

Aplicación móvil desarrollada en **Flutter** utilizando **Clean Architecture orientada a Features (Feature-First)** y **Riverpod 2.x** como gestor de estado reactivo e inyección de dependencias.

---

## 🎯 ¿Por qué Riverpod + Feature-First?

1. **Desacoplamiento total para el equipo (1 mes de plazo)**:
   - Cada feature encapsula su lógica de estado dentro de `presentation/controllers/` (o `presentation/providers/`).
   - Un desarrollador trabajando en `features/tasks/` define su propio `taskControllerProvider` sin tocar ningún otro archivo del proyecto.
2. **Inyección de Dependencias limpia y testeable**:
   - Los repositorios y datasources se declaran como `Provider<WorkerRepository>` y se inyectan en los Notifiers. Para hacer tests unitarios, basta con sobrescribir el provider con un mock usando `ProviderScope(overrides: [...])`.
3. **Manejo declarativo de estados asíncronos (`AsyncValue`)**:
   - Riverpod maneja nativamente los estados de `loading`, `error` y `data` mediante `.when(...)`, eliminando booleanos manuales (`isLoading = true/false`) y `setState()`.
4. **Sin necesidad de `build_runner`**:
   - Usamos la sintaxis estándar de `Notifier` y `AsyncNotifier` de Riverpod 2.x, lo que evita esperas de compilación de generadores de código y conflictos de archivos generados en Git.

---

## 📁 Estructura del Proyecto

```text
mobile/lib/
├── core/                               # 🌐 Compartido por toda la app
│   ├── constants/                      # URLs de API, rutas, textos fijos
│   ├── theme/                          # Colores semafóricos, fuentes y estilos
│   └── ...
│
├── features/                           # 📦 Módulos independientes por funcionalidad
│   │
│   ├── auth/                           # 🔐 Módulo de Autenticación y Roles
│   │   ├── domain/models/auth_state.dart
│   │   └── presentation/
│   │       ├── controllers/auth_controller.dart   # NotifierProvider<AuthController, AuthState>
│   │       └── screens/login_screen.dart          # ConsumerStatefulWidget / ConsumerWidget
│   │
│   ├── workers/                        # 👷 Módulo de Desmalezadores y Seguros (HU-001 / HU-002)
│   │   ├── domain/
│   │   │   ├── entities/worker.dart
│   │   │   └── repositories/worker_repository.dart
│   │   ├── data/
│   │   │   ├── models/worker_model.dart
│   │   │   └── repositories/mock_worker_repository.dart
│   │   └── presentation/
│   │       ├── controllers/workers_controller.dart # AsyncNotifierProvider<WorkersController, List<WorkerEntity>>
│   │       └── screens/
│   │           ├── workers_list_screen.dart        # ConsumerWidget con .when(data, loading, error)
│   │           └── worker_form_screen.dart         # ConsumerStatefulWidget llamando a addWorker()
│   │
│   ├── traffic_light/                  # 🚦 Módulo de Semáforo y Espacios Verdes (RF-08, RF-14)
│   │   ├── domain/entities/green_space_entity.dart
│   │   └── presentation/
│   │       ├── controllers/traffic_light_controller.dart # NotifierProvider, filtros y selectores derivados
│   │       └── screens/traffic_light_screen.dart         # ConsumerWidget con pestañas de filtro reactivas
│   │
│   ├── tasks/                          # 📸 Módulo de Registro de Tareas con Evidencia (Cámara + GPS)
│   └── inspections/                    # 📋 Módulo de Validación de Tareas por Inspector
│
├── app.dart                            # MaterialApp y configuración de temas
└── main.dart                           # Entrypoint envuelto en ProviderScope
```

---

## 🛠️ Guía Rápida de Riverpod para el Equipo

### 1. ¿Cómo crear un nuevo Notifier en tu Feature?

Crea un archivo en `features/<tu_feature>/presentation/controllers/<feature>_controller.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MiFeatureController extends Notifier<List<MiModelo>> {
  @override
  List<MiModelo> build() {
    return []; // Estado inicial
  }

  void agregarElemento(MiModelo nuevo) {
    state = [...state, nuevo]; // Actualización inmutable
  }
}

final miFeatureControllerProvider =
    NotifierProvider<MiFeatureController, List<MiModelo>>(MiFeatureController.new);
```

### 2. ¿Cómo consumirlo en una pantalla?

Convierte tu Widget en `ConsumerWidget` y usa `ref`:

```dart
class MiPantalla extends ConsumerWidget {
  const MiPantalla({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Escuchar el estado reactivamente (la pantalla se redibuja si cambia)
    final items = ref.watch(miFeatureControllerProvider);

    return Scaffold(
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (ctx, i) => Text(items[i].nombre),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 2. Ejecutar métodos del controlador (usar ref.read dentro de eventos/botones)
          ref.read(miFeatureControllerProvider.notifier).agregarElemento(nuevo);
        },
      ),
    );
  }
}
```

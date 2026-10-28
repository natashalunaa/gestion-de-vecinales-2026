# App Móvil - Sistema de Gestión y Control de Desmalezado

Aplicación móvil desarrollada en **Flutter** utilizando **Clean Architecture orientada a Features (Feature-First)**.

---

## 🎯 ¿Por qué Clean Architecture Feature-First?

Con un equipo de varias personas y un plazo de **1 mes**, la organización por capas tradicional (`lib/screens/`, `lib/models/`, `lib/controllers/`) genera cuellos de botella y conflictos de merge constantes en git.

Con **Feature-First**:
- Cada funcionalidad reside en su propia carpeta bajo `lib/features/<nombre_feature>/`.
- Cada miembro del equipo es **dueño** de su feature (ejemplo: Miembro A en `auth/`, Miembro B en `workers/`, Miembro C en `traffic_light/`).
- Pueden crear modelos, pantallas, estados y servicios sin tocar los archivos de sus compañeros.
- Se respetan las 3 capas esenciales de Clean Architecture de forma **ligera y pragmática** (sin sobreingeniería innecesaria).

---

## 📁 Estructura del Proyecto

```text
app/lib/
├── core/                               # 🌐 Compartido por toda la app
│   ├── constants/                      # URLs de API, rutas, textos fijos
│   ├── errors/                         # Definición de fallas y excepciones
│   ├── network/                        # Cliente HTTP y manejo de tokens
│   ├── theme/                          # Colores semafóricos, fuentes y estilos
│   └── widgets/                        # Componentes UI reutilizables (Botones, inputs, badges)
│
├── features/                           # 📦 Módulos independientes por funcionalidad
│   │
│   ├── auth/                           # 🔐 Módulo de Autenticación y Roles
│   │   ├── domain/                     # Entidades de Usuario, Casos de uso
│   │   ├── data/                       # Llamada a login del backend
│   │   └── presentation/               # LoginScreen, widgets
│   │
│   ├── workers/                        # 👷 Módulo de Desmalezadores y Seguros (HU-001 / HU-002)
│   │   ├── domain/
│   │   │   ├── entities/               # WorkerEntity, InsuranceEntity
│   │   │   ├── repositories/           # Contrato abstracto WorkerRepository
│   │   │   └── usecases/               # GetWorkers, RegisterWorker
│   │   ├── data/
│   │   │   ├── datasources/            # Peticiones HTTP a /api/workers
│   │   │   ├── models/                 # WorkerModel (fromJson / toJson)
│   │   │   └── repositories/           # Implementación de WorkerRepository
│   │   └── presentation/
│   │       ├── screens/                # WorkersListScreen, WorkerFormScreen
│   │       ├── state/                  # ChangeNotifier / Cubit para el estado
│   │       └── widgets/                # WorkerCard, InsuranceStatusBadge
│   │
│   ├── traffic_light/                  # 🚦 Módulo de Semáforo y Mapa de Espacios Verdes
│   │   ├── domain/                     # GreenSpaceEntity (Plaza, vereda, color de semáforo)
│   │   ├── data/                       # Obtención de espacios verdes
│   │   └── presentation/               # Mapa con pines coloreados (Verde/Amarillo/Rojo)
│   │
│   ├── tasks/                          # 📸 Módulo de Registro de Tareas con Evidencia
│   │   ├── domain/                     # TaskEntity, PhotoEvidence
│   │   ├── data/                       # Subida de fotos y GPS
│   │   └── presentation/               # TaskExecutionScreen (Cámara, GPS, envío)
│   │
│   └── claims/                         # 📢 Módulo de Reclamos Vecinales (RF-18)
│       ├── domain/
│       ├── data/
│       └── presentation/
│
├── app.dart                            # MaterialApp y configuración de rutas
└── main.dart                           # Entrypoint de Flutter
```

---

## 🛠️ Cómo implementar una nueva Feature (Paso a Paso)

Para que cualquier miembro del equipo comience:

1. **Crea la carpeta de tu feature**: `lib/features/<mi_feature>/`.
2. **Dominio primero (`domain/`)**:
   - `entities/`: La clase con los datos puros.
   - `repositories/`: La interfaz abstracta de lo que necesitas pedir o guardar.
3. **Datos (`data/`)**:
   - `models/`: La clase con `.fromJson()` y `.toJson()`.
   - `datasources/`: La función que hace `http.get` o `http.post`.
   - `repositories/`: Implementa la interfaz del dominio llamando al datasource.
4. **Presentación (`presentation/`)**:
   - `state/`: Tu gestor de estado (un simple `ChangeNotifier` o `Cubit`).
   - `screens/`: Tu pantalla Scaffold conectada a tu estado.
5. **Ruta**: Registra tu pantalla en `app.dart`.

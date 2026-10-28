# Backend - Sistema de Gestión y Control de Desmalezado

API REST desarrollada en **Go (Golang)** aplicando **Arquitectura Hexagonal (Ports & Adapters)**.

## 🎯 ¿Por qué Arquitectura Hexagonal?
El objetivo principal es desacoplar las reglas de negocio del framework HTTP y de la base de datos:
1. **El núcleo (Core)** contiene las reglas del negocio municipal (semáforos, desmalezadores habilitados, seguros vigentes) y no depende de nada externo.
2. **Los puertos (Ports)** definen las interfaces de lo que el núcleo necesita o expone.
3. **Los adaptadores (Adapters)** implementan esas interfaces:
   - **Inbound (Driving):** Reciben peticiones del exterior (ej. Handlers HTTP REST).
   - **Outbound (Driven):** Interactúan con el mundo exterior (ej. Base de datos Postgres, sistema de archivos para fotos).

De esta manera, si un desarrollador está trabajando en la lógica de cálculo del semáforo o validación de seguros, no interfiere con quien está montando los endpoints HTTP o el acceso a datos.

---

## 📁 Estructura del Proyecto

```text
backend/
├── cmd/
│   └── api/
│       └── main.go                 # Punto de entrada. Inicializa DB, inyecta dependencias y arranca servidor.
├── internal/
│   ├── core/                       # 🟢 NÚCLEO PURO (Dominio y Casos de uso)
│   │   ├── domain/                 # Entidades y Reglas de Negocio
│   │   │   ├── worker.go           # Desmalezador, Estado de Habilitación, Seguro
│   │   │   ├── green_space.go      # Plaza/Vereda, Semáforo (Verde, Amarillo, Rojo)
│   │   │   ├── job.go              # Trabajo de desmalezado, Evidencia fotográfica, GPS
│   │   │   └── user.go             # Usuarios (Admin, Inspector, Desmalezador, Vecino)
│   │   ├── ports/                  # Interfaces / Contratos
│   │   │   ├── repositories.go     # Puertos Secundarios (Salida hacia DB o Storage)
│   │   │   └── services.go         # Puertos Primarios (Entrada hacia Casos de Uso)
│   │   └── services/               # Implementación de Casos de Uso
│   │       ├── worker_service.go   # Lógica: Validar DNI, verificar seguro al día
│   │       ├── green_space_service.go # Lógica: Calcular color de semáforo según días transcurridos
│   │       └── job_service.go      # Lógica: Registrar trabajo, asociar fotos y ubicación
│   ├── adapters/                   # 🔌 ADAPTADORES (Mundo exterior)
│   │   ├── inbound/                # Adaptadores de Entrada (Driving)
│   │   │   └── http/               # Controladores HTTP REST
│   │   │       ├── router.go       # Registro de rutas
│   │   │       ├── worker_handler.go
│   │   │       ├── green_space_handler.go
│   │   │       ├── job_handler.go
│   │   │       └── middleware/     # Auth JWT, CORS, Logger
│   │   └── outbound/               # Adaptadores de Salida (Driven)
│   │       ├── storage/            # Guardado de fotos (Local o S3)
│   │       │   └── local_storage.go
│   │       └── repositories/       # Acceso a Base de Datos (PostgreSQL / SQLite / Memory)
│   │           ├── memory/         # Repositorio en memoria para tests y prototipado rápido
│   │           └── postgres/       # Implementación real con SQL
│   └── platform/                   # Configuración, variables de entorno, conexión a DB
│       ├── config/
│       └── database/
├── go.mod
└── README.md
```

---

## 👥 Guía para Desarrollar en Paralelo (Sin Pisarse)

Cuando te toque una nueva funcionalidad o Historia de Usuario (ej. *HU-001 Registrar Desmalezador*):
1. **Define tu entidad** en `internal/core/domain/worker.go`.
2. **Declara tus puertos** en `internal/core/ports/`:
   - El puerto del repositorio (ej. `Save(worker)`).
   - El puerto del caso de uso (ej. `Register(dto)`).
3. **Implementa el servicio** en `internal/core/services/worker_service.go` aplicando las validaciones de negocio (DNI único, seguro vigente).
4. **Crea el handler HTTP** en `internal/adapters/inbound/http/worker_handler.go`.
5. **Conéctalo** en `cmd/api/main.go`.

¡Listo! Tu código está totalmente encapsulado.

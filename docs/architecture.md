# Documento de Arquitectura y Diseño del Sistema
## Sistema de Gestión y Control de Desmalezado Municipal (Río Cuarto)

---

## 1. Visión General de la Arquitectura
El sistema adopta una arquitectura desacoplada de tipo **Monorepo Modular**:
- **Backend**: API REST en **Golang** con **Arquitectura Hexagonal (Ports & Adapters)**.
- **App Móvil**: **Flutter** con **Clean Architecture orientada a Features (Feature-First)** para trabajadores de campo, inspectores y vecinos.
- **Portal Web**: **Next.js 16 (App Router + TailwindCSS)** con enfoque **Feature-First** para la administración municipal y supervisión de semáforos.

---

## 2. Diagrama de Contenedores y Flujo del Sistema

```mermaid
graph TD
    subgraph Clientes ["Clientes (UI - Clean Architecture Feature-First)"]
        FlutterApp["📱 App Móvil Flutter<br/>(Desmalezador / Inspector / Vecino)"]
        WebAdmin["💻 Portal Web Next.js<br/>(Administración Municipal)"]
    end

    subgraph BackendGo ["Backend (Go - Arquitectura Hexagonal)"]
        subgraph Inbound ["🔌 Adaptadores Inbound (Driving)"]
            HttpMux["REST HTTP Handlers<br/>(WorkerHandler, JobHandler, GreenSpaceHandler)"]
        end

        subgraph Core ["🟢 Núcleo de Dominio & Casos de Uso"]
            PortsIn["Puertos de Entrada (Services)"]
            Services["Lógica de Negocio (WorkerService, JobService, TrafficLightEngine)"]
            Entities["Entidades de Dominio (Worker, GreenSpace, Job, Insurance)"]
            PortsOut["Puertos de Salida (Repositories / Storage)"]
        end

        subgraph Outbound ["🔌 Adaptadores Outbound (Driven)"]
            RepoPostgres["PostgreSQL / SQLite Adapter"]
            PhotoStorage["Storage Adapter (Local FS / S3 / MinIO)"]
        end
    end

    subgraph Externos ["Sistemas Externos"]
        DB[(Base de Datos Municipal)]
        FileStore[(Almacén de Imágenes)]
    end

    FlutterApp -->|HTTPS / JSON / Multipart| HttpMux
    WebAdmin -->|HTTPS / JSON| HttpMux
    HttpMux --> PortsIn
    PortsIn --> Services
    Services --> Entities
    Services --> PortsOut
    PortsOut --> RepoPostgres
    PortsOut --> PhotoStorage
    RepoPostgres --> DB
    PhotoStorage --> FileStore
```

---

## 3. Arquitectura Hexagonal del Backend (Go)

```mermaid
graph LR
    subgraph DrivingAdapters ["Adaptadores Primarios (Inbound)"]
        HTTPHandler["Worker HTTP Handler<br/>POST /api/workers<br/>GET /api/workers"]
        JobHandler["Job HTTP Handler<br/>POST /api/jobs"]
    end

    subgraph PortsIn ["Puertos Primarios"]
        WorkerServicePort["WorkerService Interface"]
        JobServicePort["JobService Interface"]
    end

    subgraph CoreDomain ["Dominio y Casos de Uso"]
        WorkerService["WorkerServiceImpl"]
        JobService["JobServiceImpl"]
        TrafficLightCalc["TrafficLight Calculator"]
        Entities["Worker | GreenSpace | Job | Insurance"]
    end

    subgraph PortsOut ["Puertos Secundarios"]
        WorkerRepoPort["WorkerRepository Interface"]
        JobRepoPort["JobRepository Interface"]
        StoragePort["PhotoStorage Interface"]
    end

    subgraph DrivenAdapters ["Adaptadores Secundarios (Outbound)"]
        PostgresRepo["Postgres / Memory Repo"]
        DiskStorage["Local Disk / S3 Storage"]
    end

    HTTPHandler --> WorkerServicePort
    JobHandler --> JobServicePort
    WorkerServicePort --> WorkerService
    JobServicePort --> JobService
    WorkerService --> Entities
    JobService --> Entities
    JobService --> TrafficLightCalc
    WorkerService --> WorkerRepoPort
    JobService --> JobRepoPort
    JobService --> StoragePort
    WorkerRepoPort --> PostgresRepo
    JobRepoPort --> PostgresRepo
    StoragePort --> DiskStorage
```

### Reglas clave en el Backend:
1. **El Dominio no conoce la base de datos ni HTTP**: `internal/core/domain` no importa librerías externas de base de datos ni `net/http`.
2. **Dependencias apuntan hacia adentro**: Los adaptadores dependen de las interfaces de `ports`, nunca al revés.
3. **Facilidad de Mocking y Testing**: Como los servicios dependen de interfaces (`ports.WorkerRepository`), se pueden testear unitariamente en milisegundos sin levantar una base de datos real.

---

## 4. Clean Architecture Feature-First en la UI (Flutter y Next.js)

Para que varios desarrolladores trabajen simultáneamente sin pisarse, organizamos el código por **Feature** y no por capa técnica:

```mermaid
graph TD
    subgraph FeatureWorker ["lib/features/workers/"]
        subgraph DomainLayer ["1. Domain (Puro)"]
            WorkerEntity["WorkerEntity & InsuranceEntity"]
            WorkerRepoInterface["abstract class WorkerRepository"]
            RegisterWorkerUseCase["RegisterWorkerUseCase"]
        end
        subgraph DataLayer ["2. Data"]
            WorkerModel["WorkerModel (fromJson/toJson)"]
            WorkerDatasource["WorkerRemoteDataSource (HTTP)"]
            WorkerRepoImpl["WorkerRepositoryImpl"]
        end
        subgraph PresentationLayer ["3. Presentation"]
            WorkerListScreen["WorkersListScreen"]
            WorkerFormScreen["WorkerFormScreen"]
            WorkerState["WorkerState / Controller"]
        end
    end

    PresentationLayer --> DomainLayer
    DataLayer --> DomainLayer
    WorkerRepoImpl -.->|implementa| WorkerRepoInterface
    WorkerState --> RegisterWorkerUseCase
    RegisterWorkerUseCase --> WorkerRepoInterface
```

### Módulos autónomos definidos:
| Módulo / Feature | Responsabilidad | Desarrollador sugerido |
| :--- | :--- | :--- |
| `features/auth/` | Login, selección de rol, almacenamiento de token. | Dev 1 |
| `features/workers/` | Registro de desmalezadores, consulta de nómina, control de pólizas (HU-001, HU-002). | Dev 2 |
| `features/traffic_light/` | Semáforo municipal (Verde/Amarillo/Rojo), cálculo de días y mapa de espacios verdes. | Dev 3 |
| `features/tasks/` | Ejecución de tareas: toma de fotografías antes/después y geoposicionamiento GPS. | Dev 4 |
| `features/inspections/` | Revisión, validación o rechazo de trabajos por el inspector municipal. | Dev 1 o 2 (Sprint 3) |

---

## 5. Lógica del Semáforo Municipal (RF-08, RF-14)
El estado de cada espacio verde se actualiza dinámicamente según el tipo de área y la fecha del último trabajo validado:

```text
Plazas:
  - 0 a 7 días:    🟢 VERDE (Óptimo)
  - 8 a 12 días:   🟡 AMARILLO (Alerta - próximo a mantenimiento)
  - > 12 días:     🔴 ROJO (Urgente - desmalezado atrasado)

Veredas y Ochavas:
  - 0 a 20 días:   🟢 VERDE (Óptimo)
  - 21 a 30 días:  🟡 AMARILLO (Alerta)
  - > 30 días:     🔴 ROJO (Urgente)
```

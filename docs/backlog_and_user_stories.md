# Product Backlog & Historias de Usuario
## Sistema de Gestión y Control de Desmalezado Municipal

Este documento contiene el desglose detallado de Historias de Usuario, criterios de aceptación y la estructura para cargar los issues en **GitHub Projects**.

---

## 📐 Criterios de Calidad (SQA - Definition of Done / DoD)
Una tarea o issue se considera **Terminada (Done)** únicamente cuando:
1. ✅ **Compilación limpia**: El código compila sin errores ni warnings críticos en Backend (Go), App (Flutter) o Web (Next.js).
2. 🧪 **Tests unitarios**: Las reglas de negocio de la feature cuentan con tests unitarios pasando.
3. 🔄 **CI / Linter**: Pasa el linter del stack correspondiente (`go vet`, `flutter analyze`, `pnpm run lint`).
4. 👥 **Code Review**: Fue revisado y aprobado mediante un Pull Request por al menos otro integrante del equipo.
5. 📱 **Criterios de Aceptación cumplidos**: Se verificó manualmente el flujo descripto en la Historia de Usuario.

---

## 📋 Historias de Usuario Detalladas

### HU-001: Registrar Desmalezador (RF-01)
- **Tipo**: `feature`
- **Prioridad**: Alta | **Estimación**: 3 SP (Puntos de Historia) / T-Shirt M
- **Declaración**:
  > Como **administrador municipal**, quiero **registrar nuevos desmalezadores en el sistema** para **mantener actualizado el registro de trabajadores habilitados**.
- **Criterios de Aceptación**:
  - [x] Si el administrador ingresa todos los datos obligatorios (DNI, Nombre, Apellido) y el DNI no está registrado, el sistema guarda al desmalezador.
  - [x] Si el administrador intenta registrar un DNI ya existente, el sistema bloquea el guardado e informa error de duplicado.
  - [x] Si faltan campos obligatorios, el formulario resalta los campos faltantes y no envía la petición.
  - [x] Si se registra sin seguro cargado, el desmalezador se guarda automáticamente con estado `PENDIENTE_HABILITACION`.

---

### HU-002: Gestionar Seguros de Desmalezadores (RF-03, RF-04, RF-05)
- **Tipo**: `feature`
- **Prioridad**: Alta | **Estimación**: 3 SP / T-Shirt M
- **Declaración**:
  > Como **administrador municipal**, quiero **cargar y verificar los seguros de accidentes personales de los trabajadores** para **garantizar que solo realicen tareas quienes cuenten con cobertura vigente**.
- **Criterios de Aceptación**:
  - [x] Debe permitir registrar número de póliza, compañía aseguradora y fecha de vencimiento.
  - [x] Si la fecha de vencimiento es posterior al día de hoy, el trabajador pasa a estado `HABILITADO`.
  - [x] Si la póliza está vencida o falta información, el trabajador pasa a `PENDIENTE_HABILITACION` / `INHABILITADO`.
  - [x] El sistema debe alertar visualmente (color amarillo/rojo) en el listado cuando un seguro esté próximo a vencer (menos de 7 días).

---

### HU-003: Visualizar Semáforo de Espacios Verdes (RF-06, RF-07, RF-08, RF-14)
- **Tipo**: `feature`
- **Prioridad**: Alta | **Estimación**: 5 SP / T-Shirt L
- **Declaración**:
  > Como **administrador municipal o inspector**, quiero **visualizar en un mapa/lista el estado de mantenimiento de plazas y veredas mediante un semáforo** para **identificar rápidamente qué áreas requieren intervención urgente**.
- **Criterios de Aceptación**:
  - [x] Cada espacio verde debe mostrar su nombre, barrio, tipo (Plaza / Vereda / Ochava) y color semafórico.
  - [x] Plazas: &le; 7 días (Verde), 8 a 12 días (Amarillo), &gt; 12 días (Rojo).
  - [x] Veredas/Ochavas: &le; 20 días (Verde), 21 a 30 días (Amarillo), &gt; 30 días (Rojo).
  - [x] El cálculo se realiza automáticamente en base a la fecha de la última tarea aprobada.

---

### HU-004: Registrar Tarea con Evidencia Fotográfica y GPS (RF-09, RF-10, RF-11, RF-12)
- **Tipo**: `feature`
- **Prioridad**: Alta | **Estimación**: 5 SP / T-Shirt L
- **Declaración**:
  > Como **desmalezador o responsable vecinal**, quiero **registrar el trabajo realizado enviando fotos (antes/después) y mi ubicación GPS** para **evidenciar la finalización del mantenimiento**.
- **Criterios de Aceptación**:
  - [x] El usuario debe poder seleccionar el espacio verde y asignar a los desmalezadores intervinientes.
  - [x] La app debe capturar las coordenadas GPS del dispositivo al momento de la carga.
  - [x] Debe requerir al menos 1 fotografía de evidencia.
  - [x] El trabajo se crea con estado `PENDIENTE` de validación por inspector.
  - [x] El sistema calcula un hash SHA-256 de la foto para alertar si la misma imagen ya fue utilizada en otro trabajo.

---

### HU-005: Validar o Rechazar Trabajos Realizados (RF-13, RF-15)
- **Tipo**: `feature`
- **Prioridad**: Media-Alta | **Estimación**: 3 SP / T-Shirt M
- **Declaración**:
  > Como **inspector municipal**, quiero **revisar las fotos y ubicación del trabajo y aprobarlo o rechazarlo** para **certificar que el desmalezado se hizo conforme a los estándares municipales**.
- **Criterios de Aceptación**:
  - [x] El inspector accede a la lista de trabajos en estado `PENDIENTE`.
  - [x] Puede visualizar las fotos cargadas y la ubicación en el mapa.
  - [x] Si presiona "Aprobar", el trabajo pasa a `APROBADO` y se actualiza la fecha de último mantenimiento del espacio verde (volviendo el semáforo a `VERDE`).
  - [x] Si presiona "Rechazar", debe ingresar obligatoriamente un motivo u observación.

---

### HU-006: Reclamos Vecinales de Desmalezado (RF-18)
- **Tipo**: `feature`
- **Prioridad**: Media | **Estimación**: 3 SP / T-Shirt M
- **Declaración**:
  > Como **vecino de la ciudad**, quiero **ingresar un reclamo indicando una zona con maleza alta** para **notificar a la municipalidad de la necesidad de corte**.
- **Criterios de Aceptación**:
  - [x] Formulario sencillo con dirección o selección en mapa, foto opcional y descripción.
  - [x] Genera un ticket o alerta visible para la administración municipal.

---

## 🗂️ Tabla de Issues para Cargar en GitHub Projects

| ID Issue | Título | Tipo | Prioridad | Estimación (SP) | Responsable sugerido |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **ISSUE-1** | Setup inicial de repositorios, CI y estructura Hexagonal/Clean | `gestión` | Alta | 2 SP | DevOps / Tech Lead |
| **ISSUE-2** | [Backend] Modelo de dominio Worker y CRUD de Desmalezadores (HU-001) | `feature` | Alta | 3 SP | Dev Backend |
| **ISSUE-3** | [Backend] Lógica de evaluación de pólizas de seguro (HU-002) | `feature` | Alta | 2 SP | Dev Backend |
| **ISSUE-4** | [Flutter] Pantalla de Login y selección de rol | `feature` | Media | 2 SP | Dev Flutter A |
| **ISSUE-5** | [Flutter] Módulo de Desmalezadores: Lista y Formulario (HU-001) | `feature` | Alta | 3 SP | Dev Flutter B |
| **ISSUE-6** | [Web] Panel Dashboard y Tabla de Desmalezadores con Next.js | `feature` | Alta | 3 SP | Dev Web |
| **ISSUE-7** | [Backend] Lógica de motor de semáforos y espacios verdes (RF-08) | `feature` | Alta | 3 SP | Dev Backend |
| **ISSUE-8** | [Flutter] Pantalla y widget de semáforo de espacios verdes | `feature` | Alta | 3 SP | Dev Flutter A |
| **ISSUE-9** | [Backend] Endpoint de carga de trabajos, evidencias multipart y GPS | `feature` | Alta | 5 SP | Dev Backend |
| **ISSUE-10**| [Flutter] Captura de foto con cámara y geolocalización GPS | `feature` | Alta | 5 SP | Dev Flutter B |
| **ISSUE-11**| [Web/Flutter] Flujo de aprobación/rechazo de inspector (HU-005) | `feature` | Media | 3 SP | Dev Web / Dev Flutter |
| **ISSUE-12**| [Backend/Auditoría] Detección de fotos duplicadas mediante hashing | `investigación` | Media | 2 SP | Dev Backend |
| **ISSUE-13**| [Flutter/Web] Módulo de reclamos vecinales sencillos (RF-18) | `feature` | Baja | 3 SP | Dev Flutter A |
| **ISSUE-14**| Pruebas de integración E2E y demo final municipal | `gestión` | Alta | 3 SP | Todo el equipo |

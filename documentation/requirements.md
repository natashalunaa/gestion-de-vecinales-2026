<div style="display: flex; justify-content: space-around">
   <img src="https://www.unrc.edu.ar/img/escudounrc.jpg" alt="Unrc" style="height: 100px;">
   <img src="https://www.exa.unrc.edu.ar/wp-content/uploads/2022/03/LOGO-ICONO-WEB.png" alt="Facultad de Ciencias Exactas" style="height: 100px;">
</div>

# Contenidos
- [Desarrolladores](#Desarrolladores)
- [Introduccion](#módulo-de-gestión-de-desmalezado)
- [Problema a resolver](#problema-a-resolver)
- [Funcionalidades](#usuarios-del-sistema-y-funcionalidades-principales)
- [Restricciones tecnicas](#restricciones-técnicas)
- [Tecnologias elegidas](#tecnologías-elegidas)
- [Organización del equipo](#organización-del-equipo)

# Proyecto de Extensión UNRC 2026
## Vecinales - Municipalidad de Río Cuarto

## Desarrolladores
* *Fernandez Nicolas*
* *Luna Natasha*
* *Mezzano Joaquin*
* *Pari Jennifer*
* *Trimboli Ricardo*

## Módulo de Gestión de Desmalezado
> Este módulo tiene como objetivo administrar el registro de los trabajadores de desmalezado (cuadrillas o particulares), controlar el estado de mantenimiento de los espacios verdes de las vecinales mediante un sistema de indicadores, y registrar las intervenciones realizadas.

### Problema a resolver
> Actualmente no existe un registro centralizado digitalizado ni estructurado para administrar a los desmalezadores ni los espacios verdes a intervenir. Esto dificulta el seguimiento de las frecuencias de corte (plazas cada 10 días, veredas/ochavas 1 vez al mes), el control de los seguros de los trabajadores y la comprobación de la ejecución efectiva del servicio. Se busca resolver esta falta de control mediante una plataforma compuesta por una aplicación web administrativa, una aplicación móvil para trabajo de campo y un portal público para el vecino.

---

### Usuarios del Sistema y Funcionalidades Principales

- **Super Administrador (Municipalidad)**
> * Empadronar desmalezadores (modalidad individual y cuadrillas) y gestionar sus datos.
> * Cargar y supervisar los seguros obligatorios y vigencias de matrículas (con alertas de vencimiento).
> * Visualizar el listado y estado de todas las plazas y ochavas por ejido vecinal.
> * Validar la ejecución del trabajo en tiempo real.
> * Consultar un panel de métricas y estadísticas (tiempos promedio de corte, cantidad de intervenciones, desmalezadores validados activos).

- **Encargado de Vecinal**
> * Visualizar el estado de los espacios verdes dentro de su ejido vecinal.
> * Gestionar reemplazos de desmalezadores en caso de ausencias o imprevistos.
> * Supervisar las tareas asignadas dentro de la ventana de tiempo estipulada (10 días).

- **Desmalezado / Cuadrilla (App Móvil)**
> * Consultar las tareas y zonas asignadas en su ejido.
> * Registrar el inicio y finalización del desmalezado.
> * Capturar y enviar evidencia fotográfica (fotos del espacio antes y después del corte) para la validación de la tarea.

- **Vecino / Ciudadano**
> * Consultar un mapa o listado simple con el estado actual de los espacios verdes de su barrio.
> * Acceder a un portal simple para el registro de reclamos por desmalezado pendiente o deficiente.

---

### Restricciones Técnicas

> * **Arquitectura Multiplataforma:**
>> Coexistencia de una plataforma Web para administración y una App Móvil optimizada para la carga de datos y GPS en territorio.
> * **Validación de Evidencia:**
>> Registro de fotos pre y post intervención con control de duplicados temporales e integración de métricas fotográficas.
> * **Gestión de Permisos y Roles:**
>> Control de accesos estricto con perfiles diferenciados (Municipalidad, Vecinal, Desmalezador, Vecino).
> * **Seguimiento Geográfico y Consistencia:**
>> Geolocalización obligatoria al validar el inicio y fin de las tareas.
> * **Alertas y Notificaciones:**
>> Notificaciones automáticas ante el vencimiento de matrículas o pólizas de seguro de los trabajadores.

---

### Tecnologías Elegidas

- **Servidor Backend: Go (Golang) / Next.js API Routes**
> * Permite construir un servicio rápido, concurrente y eficiente para el procesamiento de coordenadas GPS y gestión de la API.
> * Capacidad de respaldar los servicios directamente sobre Next.js en caso de requerir una integración simplificada.

- **Frontend Web: Next.js (React)**
> * Framework moderno enfocado en rendimiento y previsualización de enlaces dinámicos generados por los usuarios.
> * Permite construir tableros administrativos interactivos y dinámicos para la Municipalidad.

- **Aplicación Móvil: Flutter**
> * Permite compilar de forma nativa para dispositivos móviles desde un único código base.
> * Facilidad para integrar el uso de la cámara del dispositivo, geolocalización por GPS y consumo de APIs.

- **Base de Datos: PostgreSQL**
> * Motor relacional para garantizar la consistencia de los datos entre desmalezadores, espacios verdes, reclamos y estados de seguros.

- **Herramientas de Desarrollo:**
> * Visual Studio Code como IDE principal.
> * Git y GitHub (GitHub Projects para gestión en tablero Kanban/SCRUM con Issues y Milestones).

---

### Organización del Equipo
> * **Metodología:** SCRUM.
> * **Seguimiento:** Tablero de GitHub Projects (Backlog, En Proceso, Finalizado) con definición de Issues asociadas a requerimientos funcionales y técnicos.
> * **Repositorio Unificado:** Organización de la estructura del proyecto en módulos bien delimitados para garantizar el trabajo colaborativo en paralelo.

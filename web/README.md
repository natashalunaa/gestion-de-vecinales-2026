# Web Portal - Sistema de Gestión y Control de Desmalezado

Portal administrativo web desarrollado en **Next.js 16 (App Router + TailwindCSS)** con arquitectura modular **Feature-First**.

---

## 🎯 Arquitectura en el Frontend Web (Feature-First)

Para asegurar que los miembros del equipo puedan trabajar en paralelo sin colisiones:
1. **`app/` (App Router)** contiene únicamente la definición de rutas (`page.tsx`, `layout.tsx`). Son páginas *delgadas* (thin pages) cuya única función es importar los componentes de la feature correspondiente.
2. **`src/features/<feature>/`** contiene toda la lógica específica del módulo:
   - `components/`: Tablas, formularios, tarjetas y modales propios.
   - `services/`: Llamadas al backend de Go (`fetch('/api/...')`).
   - `types/`: Tipos e interfaces TypeScript del dominio.
3. **`src/shared/`**: Componentes visuales genéricos (botones, modales, alertas) para no duplicar código UI.

---

## 📁 Estructura del Proyecto

```text
web/
├── app/                                # 🌐 Enrutamiento Next.js App Router
│   ├── layout.tsx                      # Layout raíz con navbar y pie institucional
│   ├── page.tsx                        # Dashboard municipal principal
│   ├── desmalezadores/page.tsx         # Gestión de trabajadores y pólizas (HU-001)
│   └── semaforo/page.tsx               # Monitoreo semafórico de plazas y veredas (RF-08)
│
├── src/
│   ├── features/                       # 📦 Módulos independientes
│   │   │
│   │   ├── workers/                    # Feature: Desmalezadores y Seguros
│   │   │   ├── components/             # WorkersTable.tsx, WorkerRegisterModal.tsx
│   │   │   ├── services/               # workersApi.ts
│   │   │   └── types/                  # worker.types.ts
│   │   │
│   │   ├── traffic-light/              # Feature: Semáforo de Espacios Verdes
│   │   │   ├── components/             # TrafficLightGrid.tsx, GreenSpaceCard.tsx
│   │   │   └── types/                  # trafficLight.types.ts
│   │   │
│   │   └── validation/                 # Feature: Validación de Trabajos e Imágenes (RF-13)
│   │       ├── components/             # PhotoComparison.tsx, JobApprovalModal.tsx
│   │       └── types/
│   │
│   └── shared/                         # 🧩 Componentes transversales compartidos
│       ├── components/                 # StatusBadge.tsx, Navbar.tsx
│       └── lib/                        # api-client.ts (Base URL, headers)
│
├── package.json
└── README.md
```

---

## 🚀 Conexión con el Backend Go

Por defecto, los servicios en `src/features/*/services/` consumen la API de Go corriendo en `http://localhost:8080/api`.
Puedes configurar la variable de entorno en `.env.local`:
```env
NEXT_PUBLIC_API_URL=http://localhost:8080/api
```

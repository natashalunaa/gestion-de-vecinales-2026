import Link from "next/link";

export default function Home() {
  return (
    <div className="min-h-screen bg-zinc-100 font-sans text-zinc-900">
      {/* Header Institucional */}
      <header className="border-b border-zinc-200 bg-white">
        <div className="mx-auto flex max-w-6xl items-center justify-between px-6 py-4">
          <div className="flex items-center gap-3">
            <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-emerald-700 text-white font-bold text-lg">
              🌱
            </div>
            <div>
              <h1 className="text-lg font-bold leading-tight text-zinc-900">
                Sistema de Gestión y Control de Desmalezado
              </h1>
              <p className="text-xs text-zinc-500">Gobierno de Río Cuarto</p>
            </div>
          </div>
          <div className="text-right">
            <span className="inline-flex items-center rounded-md bg-emerald-50 px-2.5 py-1 text-xs font-semibold text-emerald-700 border border-emerald-200">
              Admin Municipal
            </span>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="mx-auto max-w-6xl px-6 py-10">
        <div className="mb-8">
          <h2 className="text-2xl font-bold tracking-tight text-zinc-900">
            Panel de Control de Mantenimiento Urbano
          </h2>
          <p className="text-sm text-zinc-600">
            Supervisión del estado de espacios verdes, asignación de cuadrillas y validación de evidencias fotográficas.
          </p>
        </div>

        {/* Resumen Semafórico (RF-08, RF-14) */}
        <div className="grid grid-cols-1 gap-4 sm:grid-cols-3 mb-8">
          <div className="rounded-xl border border-emerald-200 bg-emerald-50 p-5 shadow-sm">
            <div className="flex items-center justify-between">
              <span className="text-sm font-semibold text-emerald-800">Semáforo Verde</span>
              <span className="h-3 w-3 rounded-full bg-emerald-600 animate-pulse"></span>
            </div>
            <div className="mt-3 text-3xl font-extrabold text-emerald-950">28</div>
            <p className="mt-1 text-xs text-emerald-700">Espacios al día (&lt;10 días desde el último corte)</p>
          </div>

          <div className="rounded-xl border border-amber-200 bg-amber-50 p-5 shadow-sm">
            <div className="flex items-center justify-between">
              <span className="text-sm font-semibold text-amber-800">Semáforo Amarillo</span>
              <span className="h-3 w-3 rounded-full bg-amber-500"></span>
            </div>
            <div className="mt-3 text-3xl font-extrabold text-amber-950">9</div>
            <p className="mt-1 text-xs text-amber-700">Próximos a vencer (10 a 15 días)</p>
          </div>

          <div className="rounded-xl border border-red-200 bg-red-50 p-5 shadow-sm">
            <div className="flex items-center justify-between">
              <span className="text-sm font-semibold text-red-800">Semáforo Rojo</span>
              <span className="h-3 w-3 rounded-full bg-red-600"></span>
            </div>
            <div className="mt-3 text-3xl font-extrabold text-red-950">4</div>
            <p className="mt-1 text-xs text-red-700">Corte urgente requerido (&gt;15 días)</p>
          </div>
        </div>

        {/* Módulos de Trabajo (Clean Architecture / Feature-First) */}
        <div className="grid grid-cols-1 gap-6 md:grid-cols-2">
          {/* Módulo Desmalezadores */}
          <div className="rounded-xl border border-zinc-200 bg-white p-6 shadow-sm flex flex-col justify-between">
            <div>
              <div className="flex items-center gap-2 text-emerald-700 font-semibold text-sm">
                <span>HU-001 & HU-002</span>
              </div>
              <h3 className="mt-2 text-xl font-bold text-zinc-900">
                Desmalezadores y Seguros
              </h3>
              <p className="mt-2 text-sm text-zinc-600">
                Registro de trabajadores, verificación de DNI duplicado, control de fecha de vencimiento de seguros de accidentes personales y estado de habilitación.
              </p>
            </div>
            <div className="mt-6">
              <Link
                href="/desmalezadores"
                className="inline-flex items-center rounded-lg bg-zinc-900 px-4 py-2.5 text-sm font-semibold text-white hover:bg-zinc-800 transition"
              >
                Abrir Nómina de Desmalezadores &rarr;
              </Link>
            </div>
          </div>

          {/* Módulo Validación de Trabajos */}
          <div className="rounded-xl border border-zinc-200 bg-white p-6 shadow-sm flex flex-col justify-between">
            <div>
              <div className="flex items-center gap-2 text-teal-700 font-semibold text-sm">
                <span>RF-09, RF-11 & RF-13</span>
              </div>
              <h3 className="mt-2 text-xl font-bold text-zinc-900">
                Validación de Trabajos y Evidencias
              </h3>
              <p className="mt-2 text-sm text-zinc-600">
                Revisión de fotos antes/después enviadas por cuadrillas, geolocalización GPS y aprobación o rechazo por parte del inspector municipal.
              </p>
            </div>
            <div className="mt-6">
              <span className="inline-flex items-center rounded-lg bg-zinc-100 px-4 py-2.5 text-sm font-semibold text-zinc-500 cursor-not-allowed">
                Módulo en desarrollo (Sprint 2)
              </span>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}

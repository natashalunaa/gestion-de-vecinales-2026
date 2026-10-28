import { WorkersTable } from '@/src/features/workers/components/WorkersTable';
import Link from 'next/link';

export const metadata = {
  title: 'Gestión de Desmalezadores | Municipalidad',
};

export default function DesmalezadoresPage() {
  return (
    <div className="min-h-screen bg-zinc-50 p-6 md:p-10 font-sans">
      <div className="mx-auto max-w-6xl">
        <div className="mb-6 flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
          <div>
            <div className="flex items-center gap-2 text-sm text-zinc-500 mb-1">
              <Link href="/" className="hover:underline">Dashboard</Link>
              <span>/</span>
              <span>Desmalezadores</span>
            </div>
            <h1 className="text-2xl font-bold text-zinc-900">
              Nómina y Habilitación de Desmalezadores (HU-001 / HU-002)
            </h1>
            <p className="text-sm text-zinc-600">
              Control de trabajadores autorizados, vigencia de seguros de accidentes personales y estado operativo.
            </p>
          </div>
          <button className="inline-flex items-center justify-center rounded-lg bg-emerald-700 px-4 py-2 text-sm font-semibold text-white shadow hover:bg-emerald-800 transition">
            + Nuevo Desmalezador
          </button>
        </div>

        <WorkersTable />
      </div>
    </div>
  );
}

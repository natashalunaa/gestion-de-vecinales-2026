import { Worker, CreateWorkerInput } from '../types/worker.types';

const API_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8080/api';

export async function fetchWorkers(): Promise<Worker[]> {
  try {
    const res = await fetch(`${API_URL}/workers`, { cache: 'no-store' });
    if (!res.ok) throw new Error('Error al consultar desmalezadores');
    return await res.json();
  } catch (err) {
    console.warn('Backend Go no disponible, usando datos de contingencia/mock:', err);
    return [
      {
        id: 'w-1',
        dni: '35123456',
        first_name: 'Carlos',
        last_name: 'Gómez',
        phone: '358-4567890',
        status: 'HABILITADO',
        insurance: {
          policy_number: 'SEG-2026-001',
          insurer_name: 'Rivadavia Seguros',
          expires_at: '2026-12-31T00:00:00Z',
        },
        created_at: new Date().toISOString(),
      },
      {
        id: 'w-2',
        dni: '40987654',
        first_name: 'Marcos',
        last_name: 'López',
        phone: '358-4112233',
        status: 'PENDIENTE_HABILITACION',
        insurance: {
          policy_number: 'SEG-2025-999',
          insurer_name: 'Sancor Seguros',
          expires_at: '2026-01-15T00:00:00Z',
        },
        created_at: new Date().toISOString(),
      },
    ];
  }
}

export async function createWorker(input: CreateWorkerInput): Promise<Worker> {
  const res = await fetch(`${API_URL}/workers`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(input),
  });

  if (!res.ok) {
    const errData = await res.json().catch(() => ({}));
    throw new Error(errData.error || 'Error al registrar desmalezador');
  }

  return await res.json();
}

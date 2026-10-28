export type WorkerStatus = 'HABILITADO' | 'PENDIENTE_HABILITACION' | 'INHABILITADO';

export interface Insurance {
  policy_number: string;
  insurer_name: string;
  expires_at: string;
}

export interface Worker {
  id: string;
  dni: string;
  first_name: string;
  last_name: string;
  phone: string;
  status: WorkerStatus;
  insurance?: Insurance;
  created_at: string;
}

export interface CreateWorkerInput {
  dni: string;
  first_name: string;
  last_name: string;
  phone: string;
  policy_number?: string;
  insurer_name?: string;
  expires_at?: string;
}

'use client';

import React, { useState, useEffect } from 'react';
import { Worker } from '../types/worker.types';
import { fetchWorkers } from '../services/workersApi';

export const WorkersTable: React.FC = () => {
  const [workers, setWorkers] = useState<Worker[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchWorkers()
      .then(setWorkers)
      .finally(() => setLoading(false));
  }, []);

  if (loading) {
    return <div className="p-8 text-center text-zinc-500">Cargando nómina de desmalezadores...</div>;
  }

  return (
    <div className="overflow-x-auto rounded-lg border border-zinc-200 bg-white shadow-sm">
      <table className="min-w-full divide-y divide-zinc-200 text-left text-sm text-zinc-700">
        <thead className="bg-zinc-50 font-medium text-zinc-900">
          <tr>
            <th className="px-4 py-3">Nombre Completo</th>
            <th className="px-4 py-3">DNI</th>
            <th className="px-4 py-3">Teléfono</th>
            <th className="px-4 py-3">Estado de Habilitación</th>
            <th className="px-4 py-3">Seguro / Póliza</th>
          </tr>
        </thead>
        <tbody className="divide-y divide-zinc-100">
          {workers.map((w) => {
            const isEnabled = w.status === 'HABILITADO';
            return (
              <tr key={w.id} className="hover:bg-zinc-50">
                <td className="px-4 py-3 font-semibold text-zinc-900">
                  {w.first_name} {w.last_name}
                </td>
                <td className="px-4 py-3">{w.dni}</td>
                <td className="px-4 py-3">{w.phone}</td>
                <td className="px-4 py-3">
                  <span
                    className={`inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-semibold ${
                      isEnabled
                        ? 'bg-emerald-100 text-emerald-800'
                        : 'bg-amber-100 text-amber-800'
                    }`}
                  >
                    {isEnabled ? 'Habilitado' : 'Pendiente de habilitación'}
                  </span>
                </td>
                <td className="px-4 py-3">
                  {w.insurance ? (
                    <div>
                      <div className="font-medium">{w.insurance.insurer_name}</div>
                      <div className="text-xs text-zinc-500">Póliza: {w.insurance.policy_number}</div>
                    </div>
                  ) : (
                    <span className="text-xs text-red-600 font-medium">Sin seguro cargado</span>
                  )}
                </td>
              </tr>
            );
          })}
        </tbody>
      </table>
    </div>
  );
};

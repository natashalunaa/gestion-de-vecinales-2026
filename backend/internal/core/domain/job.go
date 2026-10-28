package domain

import "time"

type JobStatus string

const (
	JobStatusPending  JobStatus = "PENDIENTE"  // Cargado por desmalezador/vecinal
	JobStatusApproved JobStatus = "APROBADO"   // Validado por inspector (RF-13)
	JobStatusRejected JobStatus = "RECHAZADO"  // Rechazado con observaciones
)

// PhotoEvidence representa la evidencia fotográfica del trabajo (RF-11)
type PhotoEvidence struct {
	ID        string    `json:"id"`
	URL       string    `json:"url"`
	Hash      string    `json:"hash"` // Para prevenir fotos duplicadas / reutilizadas
	TakenAt   time.Time `json:"taken_at"`
	IsBefore  bool      `json:"is_before"` // Antes o después del desmalezado
}

// Location representa las coordenadas GPS registradas durante la labor (RF-12)
type Location struct {
	Latitude  float64 `json:"latitude"`
	Longitude float64 `json:"longitude"`
}

// Job representa un trabajo de desmalezado realizado (RF-09, RF-10)
type Job struct {
	ID           string          `json:"id"`
	GreenSpaceID string          `json:"green_space_id"`
	WorkerIDs    []string        `json:"worker_ids"` // Cuadrilla o individual
	Status       JobStatus       `json:"status"`
	Photos       []PhotoEvidence `json:"photos"`
	Location     Location        `json:"location"`
	PerformedAt  time.Time       `json:"performed_at"`
	ValidatedBy  *string         `json:"validated_by,omitempty"` // ID del inspector
	ValidatedAt  *time.Time      `json:"validated_at,omitempty"`
	Notes        string          `json:"notes,omitempty"`
}

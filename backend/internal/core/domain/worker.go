package domain

import (
	"errors"
	"time"
)

var (
	ErrInvalidDNI      = errors.New("el DNI proporcionado no es válido")
	ErrWorkerNotFound  = errors.New("desmalezador no encontrado")
	ErrDuplicateWorker = errors.New("ya existe un desmalezador registrado con ese DNI")
)

// StatusWorker representa la condición operativa del trabajador
type StatusWorker string

const (
	StatusHabilitado           StatusWorker = "HABILITADO"
	StatusPendienteHabilitacion StatusWorker = "PENDIENTE_HABILITACION"
	StatusInhabilitado         StatusWorker = "INHABILITADO"
)

// Insurance representa la póliza de seguro del desmalezador (RF-03, RF-04)
type Insurance struct {
	PolicyNumber string    `json:"policy_number"`
	InsurerName  string    `json:"insurer_name"`
	ExpiresAt    time.Time `json:"expires_at"`
}

// IsValid verifica si el seguro no está vencido
func (i *Insurance) IsValid() bool {
	if i == nil {
		return false
	}
	return time.Now().Before(i.ExpiresAt)
}

// Worker representa a un desmalezador municipal (RF-01, RF-02, RF-05)
type Worker struct {
	ID        string       `json:"id"`
	DNI       string       `json:"dni"`
	FirstName string       `json:"first_name"`
	LastName  string       `json:"last_name"`
	Phone     string       `json:"phone"`
	Status    StatusWorker `json:"status"`
	Insurance *Insurance   `json:"insurance,omitempty"`
	CreatedAt time.Time    `json:"created_at"`
	UpdatedAt time.Time    `json:"updated_at"`
}

// EvaluateStatus calcula el estado del desmalezador según su seguro
func (w *Worker) EvaluateStatus() {
	if w.Insurance != nil && w.Insurance.IsValid() {
		w.Status = StatusHabilitado
	} else {
		w.Status = StatusPendienteHabilitacion
	}
}

package ports

import (
	"context"
	"time"

	"github.com/dcunrc/fieldcare-management/internal/core/domain"
)

// Puertos de Entrada (Primary / Driving Ports)
// Representan los Casos de Uso expuestos por el núcleo para que sean invocados por handlers HTTP, CLI, etc.

type CreateWorkerDTO struct {
	DNI          string     `json:"dni"`
	FirstName    string     `json:"first_name"`
	LastName     string     `json:"last_name"`
	Phone        string     `json:"phone"`
	PolicyNumber string     `json:"policy_number,omitempty"`
	InsurerName  string     `json:"insurer_name,omitempty"`
	ExpiresAt    *time.Time `json:"expires_at,omitempty"`
}

type WorkerService interface {
	RegisterWorker(ctx context.Context, dto CreateWorkerDTO) (*domain.Worker, error)
	ListWorkers(ctx context.Context) ([]*domain.Worker, error)
	GetWorker(ctx context.Context, id string) (*domain.Worker, error)
	UpdateInsurance(ctx context.Context, workerID string, ins domain.Insurance) error
}

type GreenSpaceService interface {
	ListSpacesWithTrafficLight(ctx context.Context) ([]*domain.GreenSpace, error)
	GetSpace(ctx context.Context, id string) (*domain.GreenSpace, error)
	RegisterSpace(ctx context.Context, space *domain.GreenSpace) error
}

type RegisterJobDTO struct {
	GreenSpaceID string          `json:"green_space_id"`
	WorkerIDs    []string        `json:"worker_ids"`
	Latitude     float64         `json:"latitude"`
	Longitude    float64         `json:"longitude"`
	Photos       []PhotoInputDTO `json:"photos"`
	Notes        string          `json:"notes"`
}

type PhotoInputDTO struct {
	FileName string `json:"file_name"`
	Data     []byte `json:"data"`
	IsBefore bool   `json:"is_before"`
}

type JobService interface {
	RegisterJob(ctx context.Context, dto RegisterJobDTO) (*domain.Job, error)
	ValidateJob(ctx context.Context, jobID string, inspectorID string, approve bool, notes string) error
	ListPendingJobs(ctx context.Context) ([]*domain.Job, error)
}

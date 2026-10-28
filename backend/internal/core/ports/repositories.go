package ports

import (
	"context"

	"github.com/dcunrc/fieldcare-management/internal/core/domain"
)

// Puertos de Salida (Secondary / Driven Ports)
// Definen lo que el núcleo necesita que la infraestructura (DB, Storage, etc.) implemente.

type WorkerRepository interface {
	Save(ctx context.Context, worker *domain.Worker) error
	FindByID(ctx context.Context, id string) (*domain.Worker, error)
	FindByDNI(ctx context.Context, dni string) (*domain.Worker, error)
	FindAll(ctx context.Context) ([]*domain.Worker, error)
	FindEnabled(ctx context.Context) ([]*domain.Worker, error)
}

type GreenSpaceRepository interface {
	Save(ctx context.Context, space *domain.GreenSpace) error
	FindByID(ctx context.Context, id string) (*domain.GreenSpace, error)
	FindAll(ctx context.Context) ([]*domain.GreenSpace, error)
	FindByNeighborhood(ctx context.Context, neighborhood string) ([]*domain.GreenSpace, error)
}

type JobRepository interface {
	Save(ctx context.Context, job *domain.Job) error
	FindByID(ctx context.Context, id string) (*domain.Job, error)
	FindPending(ctx context.Context) ([]*domain.Job, error)
	UpdateStatus(ctx context.Context, id string, status domain.JobStatus, inspectorID string) error
	CountTotal(ctx context.Context) (int64, error)
}

type PhotoStorage interface {
	Upload(ctx context.Context, filename string, data []byte) (url string, hash string, err error)
}

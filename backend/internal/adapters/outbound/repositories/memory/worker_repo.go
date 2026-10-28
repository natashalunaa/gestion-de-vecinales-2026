package memory

import (
	"context"
	"sync"

	"github.com/dcunrc/fieldcare-management/internal/core/domain"
	"github.com/dcunrc/fieldcare-management/internal/core/ports"
)

type InMemoryWorkerRepository struct {
	mu      sync.RWMutex
	workers map[string]*domain.Worker
}

// NewInMemoryWorkerRepository crea un repositorio en memoria listo para usar
func NewInMemoryWorkerRepository() ports.WorkerRepository {
	return &InMemoryWorkerRepository{
		workers: make(map[string]*domain.Worker),
	}
}

func (r *InMemoryWorkerRepository) Save(ctx context.Context, worker *domain.Worker) error {
	r.mu.Lock()
	defer r.mu.Unlock()
	r.workers[worker.ID] = worker
	return nil
}

func (r *InMemoryWorkerRepository) FindByID(ctx context.Context, id string) (*domain.Worker, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	w, exists := r.workers[id]
	if !exists {
		return nil, domain.ErrWorkerNotFound
	}
	return w, nil
}

func (r *InMemoryWorkerRepository) FindByDNI(ctx context.Context, dni string) (*domain.Worker, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	for _, w := range r.workers {
		if w.DNI == dni {
			return w, nil
		}
	}
	return nil, nil
}

func (r *InMemoryWorkerRepository) FindAll(ctx context.Context) ([]*domain.Worker, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	list := make([]*domain.Worker, 0, len(r.workers))
	for _, w := range r.workers {
		list = append(list, w)
	}
	return list, nil
}

func (r *InMemoryWorkerRepository) FindEnabled(ctx context.Context) ([]*domain.Worker, error) {
	r.mu.RLock()
	defer r.mu.RUnlock()
	list := make([]*domain.Worker, 0)
	for _, w := range r.workers {
		if w.Status == domain.StatusHabilitado {
			list = append(list, w)
		}
	}
	return list, nil
}

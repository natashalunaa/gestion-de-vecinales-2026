package services

import (
	"context"
	"fmt"
	"strings"
	"time"

	"github.com/dcunrc/fieldcare-management/internal/core/domain"
	"github.com/dcunrc/fieldcare-management/internal/core/ports"
)

type workerService struct {
	repo ports.WorkerRepository
}

// NewWorkerService crea una nueva instancia del caso de uso de desmalezadores
func NewWorkerService(repo ports.WorkerRepository) ports.WorkerService {
	return &workerService{
		repo: repo,
	}
}

func (s *workerService) RegisterWorker(ctx context.Context, dto ports.CreateWorkerDTO) (*domain.Worker, error) {
	// 1. Validaciones básicas de campos obligatorios
	dni := strings.TrimSpace(dto.DNI)
	firstName := strings.TrimSpace(dto.FirstName)
	lastName := strings.TrimSpace(dto.LastName)

	if dni == "" || len(dni) < 7 {
		return nil, domain.ErrInvalidDNI
	}
	if firstName == "" || lastName == "" {
		return nil, fmt.Errorf("nombre y apellido son obligatorios")
	}

	// 2. Comprobar que no exista otro desmalezador con el mismo DNI (Criterio HU-001)
	existing, _ := s.repo.FindByDNI(ctx, dni)
	if existing != nil {
		return nil, domain.ErrDuplicateWorker
	}

	// 3. Crear entidad
	now := time.Now()
	worker := &domain.Worker{
		ID:        fmt.Sprintf("w-%d", now.UnixNano()),
		DNI:       dni,
		FirstName: firstName,
		LastName:  lastName,
		Phone:     strings.TrimSpace(dto.Phone),
		Status:    domain.StatusPendienteHabilitacion,
		CreatedAt: now,
		UpdatedAt: now,
	}

	// 4. Evaluar seguro si fue provisto
	if dto.PolicyNumber != "" && dto.ExpiresAt != nil {
		worker.Insurance = &domain.Insurance{
			PolicyNumber: dto.PolicyNumber,
			InsurerName:  dto.InsurerName,
			ExpiresAt:    *dto.ExpiresAt,
		}
		worker.EvaluateStatus()
	}

	// 5. Guardar mediante el puerto de salida
	if err := s.repo.Save(ctx, worker); err != nil {
		return nil, fmt.Errorf("error al persistir desmalezador: %w", err)
	}

	return worker, nil
}

func (s *workerService) ListWorkers(ctx context.Context) ([]*domain.Worker, error) {
	return s.repo.FindAll(ctx)
}

func (s *workerService) GetWorker(ctx context.Context, id string) (*domain.Worker, error) {
	return s.repo.FindByID(ctx, id)
}

func (s *workerService) UpdateInsurance(ctx context.Context, workerID string, ins domain.Insurance) error {
	worker, err := s.repo.FindByID(ctx, workerID)
	if err != nil {
		return err
	}
	if worker == nil {
		return domain.ErrWorkerNotFound
	}

	worker.Insurance = &ins
	worker.EvaluateStatus()
	worker.UpdatedAt = time.Now()

	return s.repo.Save(ctx, worker)
}

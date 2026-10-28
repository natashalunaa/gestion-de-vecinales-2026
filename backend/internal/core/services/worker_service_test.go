package services_test

import (
	"context"
	"testing"
	"time"

	"github.com/dcunrc/fieldcare-management/internal/adapters/outbound/repositories/memory"
	"github.com/dcunrc/fieldcare-management/internal/core/domain"
	"github.com/dcunrc/fieldcare-management/internal/core/ports"
	"github.com/dcunrc/fieldcare-management/internal/core/services"
)

func TestRegisterWorker_Success(t *testing.T) {
	// 1. Arrange: Usamos el repo en memoria (sin necesidad de levantar base de datos real)
	repo := memory.NewInMemoryWorkerRepository()
	service := services.NewWorkerService(repo)

	expires := time.Now().AddDate(0, 1, 0) // Vence en 1 mes
	dto := ports.CreateWorkerDTO{
		DNI:          "38123456",
		FirstName:    "Juan",
		LastName:     "Pérez",
		Phone:        "3584123456",
		PolicyNumber: "POL-999",
		InsurerName:  "La Segunda",
		ExpiresAt:    &expires,
	}

	// 2. Act
	worker, err := service.RegisterWorker(context.Background(), dto)

	// 3. Assert
	if err != nil {
		t.Fatalf("se esperaba registro exitoso, se obtuvo error: %v", err)
	}
	if worker.Status != domain.StatusHabilitado {
		t.Errorf("se esperaba estado HABILITADO, se obtuvo: %v", worker.Status)
	}

	// 4. Assert duplicado (Criterio HU-001)
	_, errDup := service.RegisterWorker(context.Background(), dto)
	if errDup != domain.ErrDuplicateWorker {
		t.Errorf("se esperaba ErrDuplicateWorker al repetir DNI, se obtuvo: %v", errDup)
	}
}

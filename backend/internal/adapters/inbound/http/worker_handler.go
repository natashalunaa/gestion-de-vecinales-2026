package http

import (
	"encoding/json"
	"net/http"

	"github.com/dcunrc/fieldcare-management/internal/core/domain"
	"github.com/dcunrc/fieldcare-management/internal/core/ports"
)

type WorkerHandler struct {
	service ports.WorkerService
}

func NewWorkerHandler(service ports.WorkerService) *WorkerHandler {
	return &WorkerHandler{service: service}
}

// RegisterRoutes registra las rutas HTTP de desmalezadores
func (h *WorkerHandler) RegisterRoutes(mux *http.ServeMux) {
	mux.HandleFunc("GET /api/workers", h.handleListWorkers)
	mux.HandleFunc("POST /api/workers", h.handleCreateWorker)
}

func (h *WorkerHandler) handleListWorkers(w http.ResponseWriter, r *http.Request) {
	workers, err := h.service.ListWorkers(r.Context())
	if err != nil {
		respondJSON(w, http.StatusInternalServerError, map[string]string{"error": err.Error()})
		return
	}
	respondJSON(w, http.StatusOK, workers)
}

func (h *WorkerHandler) handleCreateWorker(w http.ResponseWriter, r *http.Request) {
	var dto ports.CreateWorkerDTO
	if err := json.NewDecoder(r.Body).Decode(&dto); err != nil {
		respondJSON(w, http.StatusBadRequest, map[string]string{"error": "JSON inválido en el cuerpo de la petición"})
		return
	}

	worker, err := h.service.RegisterWorker(r.Context(), dto)
	if err != nil {
		if err == domain.ErrDuplicateWorker {
			respondJSON(w, http.StatusConflict, map[string]string{"error": err.Error()})
			return
		}
		if err == domain.ErrInvalidDNI {
			respondJSON(w, http.StatusBadRequest, map[string]string{"error": err.Error()})
			return
		}
		respondJSON(w, http.StatusBadRequest, map[string]string{"error": err.Error()})
		return
	}

	respondJSON(w, http.StatusCreated, worker)
}

func respondJSON(w http.ResponseWriter, status int, data any) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	_ = json.NewEncoder(w).Encode(data)
}

package main

import (
	"fmt"
	"log"
	"net/http"
	"os"

	httpAdapter "github.com/dcunrc/fieldcare-management/internal/adapters/inbound/http"
	"github.com/dcunrc/fieldcare-management/internal/adapters/outbound/repositories/memory"
	"github.com/dcunrc/fieldcare-management/internal/core/services"
)

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	// 1. Instanciar adaptadores de salida (Secundarios / Outbound)
	// Inicializamos el repositorio en memoria (fácilmente sustituible por postgres.NewPostgresWorkerRepo())
	workerRepo := memory.NewInMemoryWorkerRepository()

	// 2. Instanciar núcleo / servicios (Inyección de dependencias)
	workerService := services.NewWorkerService(workerRepo)

	// 3. Instanciar adaptadores de entrada (Primarios / Inbound)
	workerHandler := httpAdapter.NewWorkerHandler(workerService)

	// 4. Configurar Router HTTP
	mux := http.NewServeMux()

	// Ruta de bienvenida y healthcheck
	mux.HandleFunc("GET /health", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		_, _ = w.Write([]byte(`{"status":"ok","service":"fieldcare-backend"}`))
	})

	// Registrar rutas de los adaptadores
	workerHandler.RegisterRoutes(mux)

	// 5. Middleware de CORS y Logging
	handlerWithCORS := enableCORS(mux)

	addr := fmt.Sprintf(":%s", port)
	log.Printf("🚀 Servidor Hexagonal de Desmalezado iniciado en http://localhost%s\n", addr)
	if err := http.ListenAndServe(addr, handlerWithCORS); err != nil {
		log.Fatalf("Error al iniciar el servidor: %v", err)
	}
}

// enableCORS middleware para permitir peticiones desde Flutter web/móvil y Next.js
func enableCORS(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
		w.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")

		if r.Method == http.MethodOptions {
			w.WriteHeader(http.StatusOK)
			return
		}

		next.ServeHTTP(w, r)
	})
}

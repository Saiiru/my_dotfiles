package http

import (
	"net/http"

	"__MODULE_PATH__/internal/http/handlers"
)

// NewRouter registra rotas da API.
func NewRouter() http.Handler {
	mux := http.NewServeMux()

	// Health (presente se sample-api for aplicado)
	mux.HandleFunc("/health", handlers.HealthHandler("__PROJECT_NAME__"))

	return mux
}

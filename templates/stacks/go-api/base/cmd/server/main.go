package main

import (
	"log"
	"net/http"

	"__MODULE_PATH__/internal/http"
)

func main() {
	router := http.NewRouter()

	addr := ":8080"
	log.Printf("[__PROJECT_NAME__] listening on %s\n", addr)

	if err := http.ListenAndServe(addr, router); err != nil {
		log.Fatalf("server error: %v", err)
	}
}

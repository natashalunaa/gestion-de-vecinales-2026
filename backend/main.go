package main

import (
	"fmt"
	"os"
	"os/exec"
)

func main() {
	fmt.Println("🌱 Iniciando API de Gestión de Desmalezado...")
	cmd := exec.Command("go", "run", "./cmd/api")
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Stdin = os.Stdin
	if err := cmd.Run(); err != nil {
		os.Exit(1)
	}
}

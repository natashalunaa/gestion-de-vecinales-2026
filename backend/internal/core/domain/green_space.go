package domain

import "time"

// TrafficLightStatus representa el estado semaforizado del espacio verde (RF-08, RF-14)
type TrafficLightStatus string

const (
	LightGreen  TrafficLightStatus = "VERDE"    // Recientemente cortado (ej. < 10 días para plaza)
	LightYellow TrafficLightStatus = "AMARILLO" // En período de alerta (ej. 10 a 15 días)
	LightRed    TrafficLightStatus = "ROJO"     // Requiere corte urgente (> 15 días)
)

type SpaceType string

const (
	SpaceTypePlaza   SpaceType = "PLAZA"
	SpaceTypeVereda  SpaceType = "VEREDA"
	SpaceTypeOchava  SpaceType = "OCHAVA"
)

// GreenSpace representa una plaza, vereda u ochava (RF-06, RF-07)
type GreenSpace struct {
	ID             string             `json:"id"`
	Name           string             `json:"name"`
	Neighborhood   string             `json:"neighborhood"` // Barrio
	Type           SpaceType          `json:"type"`
	Latitude       float64            `json:"latitude"`
	Longitude      float64            `json:"longitude"`
	LastMaintained *time.Time         `json:"last_maintained,omitempty"`
	Status         TrafficLightStatus `json:"status"`
}

// UpdateTrafficLight actualiza el semáforo en base a los días transcurridos
func (g *GreenSpace) UpdateTrafficLight() {
	if g.LastMaintained == nil {
		g.Status = LightRed
		return
	}

	days := int(time.Since(*g.LastMaintained).Hours() / 24)

	// Lógica según tipo (Plazas cada 10 días, veredas mensual)
	if g.Type == SpaceTypePlaza {
		if days <= 7 {
			g.Status = LightGreen
		} else if days <= 12 {
			g.Status = LightYellow
		} else {
			g.Status = LightRed
		}
	} else {
		if days <= 20 {
			g.Status = LightGreen
		} else if days <= 30 {
			g.Status = LightYellow
		} else {
			g.Status = LightRed
		}
	}
}

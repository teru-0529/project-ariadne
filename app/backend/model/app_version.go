package model

import "time"

// SECTION: Business Model

// TYPE:
type AppVersion struct {
	appVersion  string // 1.0.0
	releaseDate time.Time
}

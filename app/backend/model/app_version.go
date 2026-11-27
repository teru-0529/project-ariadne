package model

import "time"

// SECTION: Business Model
type AppVersion struct {
	appVersion  string // 1.0.0
	releaseDate time.Time
}

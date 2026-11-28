package model

import "time"

// SECTION: Business Model

// TYPE:
type AppVersion struct {
	appVersion  string // 1.0.0
	releaseDate time.Time
}

// FUNCTION: Getter
func (v *AppVersion) AppVersion() string {
	return v.appVersion
}

func (v *AppVersion) ReleaseDate() time.Time {
	return v.releaseDate
}

// SECTION: Package Functions

// FUNCTION: Public Function
func GetAppVersion() *AppVersion {
	return &AppVersion{}
}

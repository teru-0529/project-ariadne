package model

import "time"

// NOTE: Overridden at build time using ldflags -X.
var (
	buildAppVersion  = "0.0.0"
	buildReleaseDate = "2026-01-01"
)

var applicationVersion = initializeAppVersion()

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

// FUNCTION: Initialization
func initializeAppVersion() *AppVersion {
	parsedReleaseDate, err := time.Parse(time.DateOnly, buildReleaseDate)
	if err != nil {
		// NOTE: An invalid build-time release date is a configuration defect.
		panic(err)
	}

	return &AppVersion{
		appVersion:  buildAppVersion,
		releaseDate: parsedReleaseDate,
	}
}

// FUNCTION: Public Function
func GetAppVersion() *AppVersion {
	return applicationVersion
}

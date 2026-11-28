package public

import "time"

// SECTION: Public Model

// TYPE:
type ApplicationInfo struct {
	AppVersion    string // 1.0.0
	ReleaseDate   time.Time
	SchemaVersion string // 1.0
}

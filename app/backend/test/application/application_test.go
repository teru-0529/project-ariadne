package application

import (
	"testing"

	"github.com/teru-0529/project-ariadne/app/backend/adapter/persistence"
	"github.com/teru-0529/project-ariadne/app/backend/service"
)

// SECTION: Application Test
func TestGetApplicationInfo(t *testing.T) {
	// TEST: Normal
	t.Run("Normal", func(t *testing.T) {
		// STEP: Arrange
		workspaceRepository := &persistence.WorkspaceRepository{}
		configureService := service.NewConfigureService(workspaceRepository)

		schemaVersion := workspaceRepository.GetSchemaVersion()

		// STEP: Act
		actual := configureService.GetApplicationInfo()

		// STEP: Assert
		// NOTE: Application information
		if actual == nil {
			t.Fatal("ApplicationInfo must not be nil")
		}

		// NOTE: App version
		expectedAppVersion := "0.0.0"
		if actual.AppVersion != expectedAppVersion {
			t.Errorf("AppVersion: got %q, want %q", actual.AppVersion, expectedAppVersion)
		}

		// NOTE: Release date
		expectedReleaseDate := "2026-01-01"
		if actual.ReleaseDate != expectedReleaseDate {
			t.Errorf("ReleaseDate: got %q, want %q", actual.ReleaseDate, expectedReleaseDate)
		}

		// NOTE: Schema version
		if actual.SchemaVersion != schemaVersion {
			t.Errorf("SchemaVersion: got %q, want %q", actual.SchemaVersion, schemaVersion)
		}
	})
}

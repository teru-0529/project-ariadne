package application

import (
	"testing"
	"time"

	"github.com/teru-0529/project-ariadne/app/backend/adapter/persistence"
	"github.com/teru-0529/project-ariadne/app/backend/service"
)

// SECTION: Application Test
func TestGetApplicationInfo(t *testing.T) {
	// TEST: Normal
	t.Run("Normal", func(t *testing.T) {
		// STEP: Arrange
		// TODO: Use the WorkspaceRepository constructor.
		workspaceRepository := &persistence.WorkspaceRepository{}
		configureService := service.NewConfigureService(workspaceRepository)

		schemaVersion := workspaceRepository.GetSchemaVersion()

		// STEP: Act
		actual := configureService.GetApplicationInfo()

		// STEP: Assert
		if actual == nil {
			t.Fatal("ApplicationInfo must not be nil")
		}

		expectedAppVersion := "0.0.0"
		if actual.AppVersion != expectedAppVersion {
			t.Errorf("AppVersion: got %q, want %q",
				actual.AppVersion, expectedAppVersion)
		}

		expectedReleaseDate := time.Date(
			2026, time.January, 1, 0, 0, 0, 0, time.UTC,
		)
		if !actual.ReleaseDate.Equal(expectedReleaseDate) {
			t.Errorf("ReleaseDate: got %v, want %v",
				actual.ReleaseDate, expectedReleaseDate)
		}

		if actual.SchemaVersion != schemaVersion {
			t.Errorf("SchemaVersion: got %q, want %q",
				actual.SchemaVersion, schemaVersion)
		}
	})
}

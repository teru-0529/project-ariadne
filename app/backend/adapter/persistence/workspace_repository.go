package persistence

import "fmt"

// NOTE: Keep the schema version at 0.9 until the production release.
const (
	schemaVersionMajor = 0
	schemaVersionMinor = 9
)

// SECTION: Repository

// TYPE:
// FUTURE: Introduce a constructor when repository initialization is required.
type WorkspaceRepository struct{}

// FUNCTION: Public Method
func (r *WorkspaceRepository) GetSchemaVersion() string {
	return fmt.Sprintf("%d.%d", schemaVersionMajor, schemaVersionMinor)
}

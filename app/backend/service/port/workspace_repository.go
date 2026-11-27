package port

// SECTION: Repository Interface
type WorkspaceRepository interface {
	GetSchemaVersion() string
}

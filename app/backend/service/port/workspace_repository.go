package port

// SECTION: Repository Interface

// TYPE:
type WorkspaceRepository interface {
	GetSchemaVersion() string
}

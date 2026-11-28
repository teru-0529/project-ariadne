package service

import (
	"time"

	"github.com/teru-0529/project-ariadne/app/backend/model"
	"github.com/teru-0529/project-ariadne/app/backend/service/port"
	"github.com/teru-0529/project-ariadne/app/backend/service/public"
)

// SECTION: Application Service

// TYPE:
type ConfigureService struct {
	workspaceRepository port.WorkspaceRepository
}

// FUNCTION: Constructor
func NewConfigureService(workspaceRepository port.WorkspaceRepository) *ConfigureService {
	return &ConfigureService{
		workspaceRepository: workspaceRepository,
	}
}

// FUNCTION: Public Method
func (s *ConfigureService) GetApplicationInfo() *public.ApplicationInfo {
	appVersion := model.GetAppVersion()
	schemaVersion := s.workspaceRepository.GetSchemaVersion()

	return &public.ApplicationInfo{
		AppVersion:    appVersion.AppVersion(),
		ReleaseDate:   appVersion.ReleaseDate().Format(time.DateOnly),
		SchemaVersion: schemaVersion,
	}
}

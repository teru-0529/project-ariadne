package service

import (
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
	return nil
}

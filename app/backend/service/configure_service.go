package service

import "github.com/teru-0529/project-ariadne/app/backend/service/public"

// SECTION: Application Service

// TYPE:
type ConfigureService struct{}

// FUNCTION: Public Method
func (s *ConfigureService) GetVersion() *public.Version {
	return nil
}

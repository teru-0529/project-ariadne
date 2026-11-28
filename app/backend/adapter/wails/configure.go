package wails

import (
	"github.com/teru-0529/project-ariadne/app/backend/service"
	"github.com/teru-0529/project-ariadne/app/backend/service/public"
)

// SECTION: Wails Boundary

// TYPE:
type Configure struct {
	configureService *service.ConfigureService
}

// FUNCTION: Constructor
func NewConfigure(configureService *service.ConfigureService) *Configure {
	return &Configure{
		configureService: configureService,
	}
}

// FUNCTION: Public Method
func (c *Configure) GetApplicationInfo() *public.ApplicationInfo {
	return c.configureService.GetApplicationInfo()
}

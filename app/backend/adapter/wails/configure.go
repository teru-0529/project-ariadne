package wails

import "github.com/teru-0529/project-ariadne/app/backend/service/public"

// SECTION: Wails Boundary

// TYPE:
type Configure struct{}

// FUNCTION: Public Method
func (c *Configure) GetVersion() *public.Version {
	return nil
}

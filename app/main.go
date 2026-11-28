package main

import (
	"embed"
	"log"

	"github.com/teru-0529/project-ariadne/app/backend/adapter/persistence"
	"github.com/teru-0529/project-ariadne/app/backend/adapter/wails"
	"github.com/teru-0529/project-ariadne/app/backend/service"
	"github.com/wailsapp/wails/v3/pkg/application"
)

// SECTION: Embedded frontend assets
// Embed the frontend build output into the application binary.
//
//go:embed all:frontend/dist
var assets embed.FS

// SECTION: Application entry point
func main() {
	// STEP: Initialize dependencies
	workspaceRepository := &persistence.WorkspaceRepository{}
	configureService := service.NewConfigureService(workspaceRepository)
	configure := wails.NewConfigure(configureService)

	// STEP: Initialize application
	app := application.New(application.Options{
		Name:        "ARIADNE",
		Description: "Design Authoring Tool",
		Services: []application.Service{
			application.NewService(configure),
		},
		Assets: application.AssetOptions{
			Handler: application.AssetFileServerFS(assets),
		},
	})

	// STEP: Configure main window
	app.Window.NewWithOptions(application.WebviewWindowOptions{
		Title:            "ARIADNE",
		Width:            1000,
		Height:           618,
		MinWidth:         960,
		MinHeight:        600,
		BackgroundColour: application.NewRGB(255, 255, 255),
		URL:              "/",
	})

	// STEP: Run application
	err := app.Run()
	if err != nil {
		log.Fatal(err)
	}
}

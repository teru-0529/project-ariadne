package main

import (
	"embed"
	"log"

	"github.com/wailsapp/wails/v3/pkg/application"
)

// Embed the frontend build output into the application binary.
//
//go:embed all:frontend/dist
var assets embed.FS

func main() {
	app := application.New(application.Options{
		Name:        "ARIADNE",
		Description: "Design Authoring Tool",
		Services:    []application.Service{},
		Assets: application.AssetOptions{
			Handler: application.AssetFileServerFS(assets),
		},
	})

	app.Window.NewWithOptions(application.WebviewWindowOptions{
		Title:            "ARIADNE",
		Width:            1000,
		Height:           618,
		BackgroundColour: application.NewRGB(255, 255, 255),
		URL:              "/",
	})

	err := app.Run()
	if err != nil {
		log.Fatal(err)
	}
}

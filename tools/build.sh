#!/usr/bin/env bash

# SECTION: Path resolution
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)" || exit 1
APP_DIR="${SCRIPT_DIR}/../app"

# SECTION: Production build
cd "${APP_DIR}" || exit 1
exec wails3 task build

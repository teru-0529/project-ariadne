import { render, screen, within } from "@testing-library/svelte";
import { describe, expect, test, vi } from "vitest";

import { GetApplicationInfo } from "../../../bindings/github.com/teru-0529/project-ariadne/app/backend/adapter/wails/configure";

import App from "../../App.svelte";

vi.mock("../../../bindings/github.com/teru-0529/project-ariadne/app/backend/adapter/wails/configure");

// SECTION: Shell Test
describe("Welcome画面を表示する", () => {
  // TEST: Normal
  test("Normal", async () => {
    // STEP: Arrange
    vi.mocked(GetApplicationInfo).mockImplementation(
      () =>
        Promise.resolve({
          AppVersion: "1.2.3",
          ReleaseDate: "2027-01-01",
          SchemaVersion: "1.0",
        }) as ReturnType<typeof GetApplicationInfo>,
    );

    // STEP: Act
    render(App);

    // STEP: Assert
    // NOTE: Welcome screen
    const main = screen.getByRole("main");
    expect(within(main).getByRole("heading", { name: "Welcome to ARIADNE" })).toBeVisible();

    // NOTE: Primary navigation
    const navigation = screen.getByRole("navigation", { name: "Primary Navigation" });
    const expectedItems = ["Elements", "DB", "API", "Config"];
    expect(within(navigation).getAllByRole("button")).toHaveLength(expectedItems.length);
    for (const item of expectedItems) {
      const button = within(navigation).getByRole("button", { name: item });
      expect(button).toBeVisible();
      expect(button).not.toHaveAttribute("aria-current");
    }

    // NOTE: App version
    const footer = screen.getByRole("contentinfo");
    const expectedAppVersion = "v1.2.3";
    expect(await within(footer).findByRole("button", { name: expectedAppVersion })).toBeVisible();

    // NOTE: Copyright
    const expectedCopyright = "© 2026-2027 PROJECT ARIADNE";
    expect(await within(footer).findByText(expectedCopyright)).toBeVisible();
  });
});

import { defineConfig } from "vitest/config";
import { svelte } from "@sveltejs/vite-plugin-svelte";
import { svelteTesting } from "@testing-library/svelte/vite";

// SECTION: Vitest configuration
export default defineConfig({
  plugins: [svelte(), svelteTesting()],
  test: {
    environment: "jsdom",
    include: ["src/test/**/*.test.ts"],
    setupFiles: ["./src/test/setup.ts"],
    passWithNoTests: true,
  },
});

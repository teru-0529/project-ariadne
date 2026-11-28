<!-- BLOCK: Script -->
<script lang="ts">
  import type { Snippet } from "svelte";

  import AriadnePrimaryNavigation from "../common/AriadnePrimaryNavigation.svelte";

  // SECTION: Props
  interface Props {
    children: Snippet;
  }

  let { children }: Props = $props();
</script>

<!-- BLOCK: Markup -->
<div class="ariadne-shell">
  <!-- SECTION: Header -->
  <header>
    <div class="brand">
      <div class="brand-accent">
        <div class="brand-bar"></div>
      </div>

      <div class="brand-title">
        <h1>PROJECT ARIADNE</h1>
      </div>
    </div>

    <AriadnePrimaryNavigation />
  </header>

  <!-- SECTION: Feature Area -->
  <main>
    {@render children()}
  </main>

  <!-- SECTION: Footer -->
  <footer>
    <!-- TODO: Derive the copyright notice from the application release date. -->
    <div class="copyright">© 2026 PROJECT ARIADNE</div>

    <div class="version">
      <!-- TODO: Display the app version received from the parent component. -->
      <button type="button" class="version-badge">v0.1.0</button>
    </div>
  </footer>
</div>

<!-- BLOCK: Style -->
<style>
  /* SECTION: Shell Layout */
  .ariadne-shell {
    width: 100%;
    height: 100%;

    display: grid;
    grid-template-rows: 48px minmax(0, 1fr) 24px;

    overflow: hidden;
  }

  /* SECTION: Header */
  header {
    min-width: 0;

    display: flex;
    align-items: stretch;
    justify-content: space-between;

    padding-right: var(--spacing-16);

    background: var(--color-background);
    border-bottom: 1px solid var(--color-border);

    overflow: hidden;
  }

  .brand {
    display: flex;
    align-items: stretch;

    flex-shrink: 0;
  }

  .brand-accent {
    position: relative;

    width: 36px;

    background: var(--color-accent-light);
  }

  .brand-bar {
    position: absolute;

    top: 0;
    right: 0;
    bottom: 0;

    width: 12px;

    background: var(--color-accent);
  }

  .brand-bar::after {
    position: absolute;

    bottom: 4px;
    left: 100%;

    width: 280px;
    height: 3px;

    content: "";
    background: linear-gradient(to right, var(--color-accent) 0%, var(--color-accent) 55%, transparent 100%);
  }

  .brand-title {
    display: flex;
    align-items: center;

    margin-left: var(--spacing-12);
  }

  .brand-title h1 {
    margin: 0;

    font-size: var(--font-size-20);
    font-weight: var(--font-weight-semibold);
    letter-spacing: 0.02em;
    white-space: nowrap;
  }

  /* SECTION: Feature Area */
  main {
    min-width: 0;
    min-height: 0;

    overflow: hidden;
  }

  /* SECTION: Footer */
  footer {
    min-width: 0;

    display: grid;
    grid-template-columns: minmax(0, 1fr) auto minmax(0, 1fr);
    align-items: center;

    padding: 0 var(--spacing-12);

    color: var(--color-text-inverse);
    background: var(--color-footer);

    font-size: var(--font-size-10);

    overflow: hidden;
  }

  .copyright {
    grid-column: 2;

    white-space: nowrap;
  }

  .version {
    grid-column: 3;
    justify-self: end;
  }

  /* SECTION: App Version Badge */
  .version-badge {
    height: 16px;

    padding: 0 var(--spacing-8);

    color: var(--color-text-inverse);
    background: rgb(255 255 255 / 12%);
    border: none;
    border-radius: 3px;

    font-size: var(--font-size-10);
    font-weight: var(--font-weight-medium);

    cursor: pointer;
  }

  .version-badge:hover {
    background: rgb(255 255 255 / 20%);
  }

  .version-badge:focus-visible {
    outline: 1px solid var(--color-text-inverse);
    outline-offset: 1px;
  }
</style>

<!-- BLOCK: Script -->
<script lang="ts">
  import type { Snippet } from "svelte";

  import AriadnePopup from "../common/AriadnePopup.svelte";
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
    <AriadnePrimaryNavigation />
  </header>

  <!-- SECTION: Feature Area -->
  <main>
    {@render children()}
  </main>

  <!-- SECTION: Footer -->
  <footer>
    <AriadnePopup />
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
  }
</style>

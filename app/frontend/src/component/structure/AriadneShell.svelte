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

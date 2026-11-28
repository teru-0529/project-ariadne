<!-- BLOCK: Script -->
<script lang="ts">
  import type { Snippet } from "svelte";

  // SECTION: Props
  interface Props {
    trigger: Snippet;
    content: Snippet;
  }

  let { trigger, content }: Props = $props();
</script>

<!-- BLOCK: Markup -->
<div class="popup">
  <!-- SECTION: Trigger -->
  {@render trigger()}

  <!-- SECTION: Content -->
  <!-- TODO: Control popup visibility through internal open state. -->
  <div class="popup-content">
    {@render content()}
  </div>
</div>

<!-- BLOCK: Style -->
<style>
  /* SECTION: Popup Layout */
  .popup {
    position: relative;
  }

  /* SECTION: Popup Content */
  .popup-content {
    position: absolute;

    right: 0;
    bottom: calc(100% + var(--spacing-8));

    z-index: 10;

    padding: var(--spacing-12);

    color: var(--color-text);
    background: var(--color-background);
    border: 1px solid var(--color-border);
    border-radius: 6px;

    box-shadow: 0 4px 12px rgb(38 59 94 / 15%);
  }
</style>

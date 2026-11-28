<!-- BLOCK: Script -->
<script lang="ts">
  import type { Snippet } from "svelte";

  // SECTION: Props
  interface Props {
    trigger: Snippet<[() => void]>;
    content: Snippet;
  }

  let { trigger, content }: Props = $props();

  // SECTION: Popup
  let isOpen = $state(false);
  let popupElement: HTMLDivElement | undefined = $state();

  // SECTION: Events

  // FUNCTION: Toggle popup
  function togglePopup(): void {
    isOpen = !isOpen;
  }

  // FUNCTION: Close popup on outside click
  function handleOutsideClick(event: MouseEvent): void {
    if (isOpen && event.target instanceof Node && !popupElement?.contains(event.target)) {
      isOpen = false;
    }
  }
</script>

<!-- BLOCK: Markup -->
<svelte:window onclick={handleOutsideClick} />

<div class="popup" bind:this={popupElement}>
  <!-- SECTION: Trigger -->
  {@render trigger(togglePopup)}

  <!-- SECTION: Content -->
  {#if isOpen}
    <div class="popup-content">
      {@render content()}
    </div>
  {/if}
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

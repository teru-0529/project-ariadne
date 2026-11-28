<!-- BLOCK: Script -->
<script lang="ts">
  // SECTION: Props
  interface Props {
    items: readonly { id: string; label: string }[];
    current: string;
    onSelect: (id: string) => void;
  }

  let { items, current, onSelect }: Props = $props();
</script>

<!-- BLOCK: Markup -->
<nav class="primary-navigation" aria-label="Primary Navigation">
  {#each items as item (item.id)}
    <button
      type="button"
      class:current={current === item.id}
      aria-current={current === item.id ? "page" : undefined}
      onclick={() => onSelect(item.id)}
    >
      {item.label}
    </button>
  {/each}
</nav>

<!-- BLOCK: Style -->
<style>
  /* SECTION: Navigation Layout */
  .primary-navigation {
    display: flex;
    align-items: stretch;

    gap: var(--spacing-8);
  }

  /* SECTION: Navigation Item */
  button {
    position: relative;

    min-width: 64px;

    padding: 0 var(--spacing-12);

    color: var(--color-text-muted);
    background: transparent;
    border: none;

    font-size: var(--font-size-12);
    font-weight: var(--font-weight-regular);
    white-space: nowrap;

    cursor: pointer;
  }

  /* SECTION: Selected State */
  button.current {
    color: var(--color-accent);

    font-weight: var(--font-weight-semibold);
  }

  button.current::after {
    position: absolute;

    right: var(--spacing-8);
    bottom: 0;
    left: var(--spacing-8);

    height: 3px;

    content: "";
    background: var(--color-accent);
  }

  /* SECTION: Focus State */
  button:focus-visible {
    outline: 2px solid var(--color-accent);
    outline-offset: -2px;

    border-radius: 4px;
  }
</style>

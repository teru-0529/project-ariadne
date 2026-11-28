<!-- BLOCK: Script -->
<script lang="ts">
  import AriadneShell from "../../component/structure/AriadneShell.svelte";

  // SECTION: Feature
  type Feature = "WELCOME" | "ELEMENTS" | "DB" | "API" | "CONFIG";

  let currentFeature: Feature = $state("WELCOME");
</script>

<!-- BLOCK: Markup -->
<AriadneShell>
  {#if currentFeature === "WELCOME"}
    <!-- SECTION: Welcome -->
    <div class="welcome">
      <h2>Welcome to ARIADNE</h2>
      <p>Design Authoring Tool</p>
    </div>
  {:else}
    <!-- SECTION: Feature Content -->
    <!-- TODO: Render the selected feature content. -->
    {currentFeature}
  {/if}
</AriadneShell>

<!-- BLOCK: Style -->
<style>
  /* SECTION: Welcome Layout */
  .welcome {
    width: 100%;
    height: 100%;

    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;

    gap: var(--spacing-8);

    background: var(--color-background);
  }

  /* SECTION: Welcome Message */
  .welcome h2 {
    margin: 0;

    color: var(--color-text);

    font-size: var(--font-size-24);
    font-weight: var(--font-weight-semibold);
  }

  .welcome p {
    margin: 0;

    color: var(--color-text-muted);

    font-size: var(--font-size-14);
    font-weight: var(--font-weight-regular);
  }
</style>

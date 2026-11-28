<!-- BLOCK: Script -->
<script lang="ts">
  import { onMount } from "svelte";

  import { GetApplicationInfo } from "../../../bindings/github.com/teru-0529/project-ariadne/app/backend/adapter/wails/configure";
  import type { ApplicationInfo } from "../../../bindings/github.com/teru-0529/project-ariadne/app/backend/service/public/models";

  import AriadneShell from "../../component/structure/AriadneShell.svelte";
  import { Version } from "../../lib/model/version";

  // SECTION: Feature
  type Feature = "WELCOME" | "ELEMENTS" | "DB" | "API" | "CONFIG";

  let currentFeature: Feature = $state("WELCOME");

  // SECTION: Application Information
  let applicationInfo: ApplicationInfo | null = $state(null);

  let version = $derived.by(() => {
    if (applicationInfo === null) {
      return null;
    }
    return new Version(applicationInfo.AppVersion, applicationInfo.ReleaseDate, applicationInfo.SchemaVersion);
  });

  let copyright = $derived.by(() => {
    const startYear = "2026";
    const releaseYear = applicationInfo?.ReleaseDate.slice(0, 4) ?? startYear;
    const years = releaseYear === startYear ? startYear : `${startYear}-${releaseYear}`;
    return `© ${years} PROJECT ARIADNE`;
  });

  // SECTION: Lifecycle
  onMount(() => {
    void loadApplicationInfo();
  });

  // FUNCTION: Load application information
  async function loadApplicationInfo(): Promise<void> {
    try {
      applicationInfo = await GetApplicationInfo();
    } catch {
      // NOTE: Failure to retrieve application information does not prevent application startup.
      // FUTURE: Log the error when frontend logging is introduced.
      applicationInfo = null;
    }
  }
</script>

<!-- BLOCK: Markup -->
<AriadneShell {version} {copyright}>
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

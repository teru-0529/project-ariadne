<!-- BLOCK: Script -->
<script lang="ts">
  import AriadneShell from "../../component/structure/AriadneShell.svelte";

  // SECTION: Feature
  type Feature = "WELCOME" | "ELEMENTS" | "DB" | "API" | "CONFIG";

  let currentFeature: Feature = $state("WELCOME");
</script>

<!-- BLOCK: Markup -->
<AriadneShell>
  {currentFeature}
</AriadneShell>

<script>
  let { size = 24, color = "currentColor", ...rest } = $props();
</script>

<svg viewBox="0 0 24 24" width={size} height={size} fill={color} class="back-icon">
  <path d="M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z" />
</svg>

<style>
  .back-icon {
    display: inline-block;
    vertical-align: middle;
  }
</style>

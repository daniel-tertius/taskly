<script>
  let { size = 24, color: stroke = "currentColor", ...rest } = $props();
</script>

<svg
  {...rest}
  width={size}
  height={size}
  viewBox="0 0 24 24"
  fill="none"
  {stroke}
  stroke-width="2"
  stroke-linecap="round"
  stroke-linejoin="round"
>
  <circle cx="12" cy="12" r="10" />
  <polyline points="12,6 12,12 16,14" />
</svg>

<script>
  let { size = 24, color: stroke = "currentColor", ...rest } = $props();
</script>

<svg
  {...rest}
  class="transition-all duration-300 {rest.class}"
  fill="none"
  viewBox="0 0 24 24"
  {stroke}
  width={size}
  height={size}
>
  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M12 4v16m8-8H4" />
</svg>

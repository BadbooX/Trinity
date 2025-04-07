<script lang="ts" setup>
import type { CustomLinkProps } from "@/types/custom-link-props";
import { defineProps } from "vue";

const props = defineProps<CustomLinkProps>();
const to = props.to;
const text = props.text;
</script>

<template>
  <RouterLink :to="to">
    {{ text }}
  </RouterLink>
</template>

<style lang="css" scoped>
a {
  text-decoration: none;
  color: #de1628;
  font-size: 1.1em;
  font-family: 'Railway', sans-serif;
  font-weight: 500;
}

a:hover {
    color: #bf1321;
}
</style>

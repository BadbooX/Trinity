<script lang="ts" setup>
import type { CustomLinkProps } from "@/types/custom-link-props";
import { defineProps } from "vue";

const props = defineProps<CustomLinkProps>();
const href = props.to;
const text = props.text;
</script>

<template>
  <a :href="href">
    {{ text }}
  </a>
</template>

<style scoped>
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

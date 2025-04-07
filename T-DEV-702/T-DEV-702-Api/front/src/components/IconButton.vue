<script lang="ts" setup>
import type { ButtonProps } from "@/types/button-props";
import { defineProps } from "vue";

const props = defineProps<ButtonProps>();
const onClick = props.onClick;
</script>

<template>
  <button @click="onClick">
    <slot>
      <!-- Slot reserved for the material icon. Exemple: <IconAdd color=#000 font-size="24px" /> -->
    </slot>
  </button>
</template>

<style scoped>
button {
  background-color: transparent;
  border: none;
  cursor: pointer;
  font-size: 1.5em;
  color: #000;
  border-radius: 50%;
  display: flex;
  justify-content: center;
  align-items: center;
  width: fit-content;
}

button:hover {
  color: #000;
  background-color: #f8e2e2;
}
</style>

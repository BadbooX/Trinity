<script lang="ts" setup>
import { defineProps } from "vue";
import type { CustomInputProps } from "@/types/custom-input-props";

const props = defineProps<CustomInputProps>();
const label = props.label;
const type = props.type;
const placeholder = props.placeholder;
const model = defineModel();
</script>

<template>
  <div>
    <label>
      <slot class="icon">
        <!-- Slot reserved for the icon. Exemple: <IconAdd /> -->
      </slot>
      {{ label }}
    </label>
    <input :type="type" :placeholder="placeholder" v-model="model" />
  </div>
</template>

<style scoped>
label {
  display: flex;
  font-family: "Railway", sans-serif;
  align-items: center;
  font-size: 1.2em;
}

input {
  padding: 0.5rem;
  font-size: 1em;
  border: none;
  border-radius: 0.5rem;
  background-color: #e8b3b8;
  color: #000;
  font-size: 1em;
}

input:focus {
  outline: 2px solid #de1628;
  background-color: #f5d1d4;
}

.icon {
  color: #de1628;
  font-size: 1.5em;
}

div{
  display: flex;
  flex-direction: column;
  width: fit-content;
}
</style>

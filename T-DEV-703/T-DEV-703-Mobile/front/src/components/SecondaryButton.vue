<script lang="ts" setup>
import { defineProps } from 'vue';
import type { ButtonProps } from '@/types/button-props';

const props = defineProps<ButtonProps>();
const text = props.text;
const onClick = props.onClick;
const disabled = props.disabled;

</script>

<template>
  <button @click="onClick" :disabled="disabled">
    <slot class="icon">
        <!-- Slot reserved for the icon -->
    </slot>
    <span>{{ text }}</span>
  </button>
</template>

<style scoped>

    button {
        padding: 0.5rem 1rem;
        font-size: 1.1em;
        border: none;
        border-radius: 6px;
        margin-top: 0.5rem;
        text-decoration: underline 3px solid #DE1628;
        color: #000;
        font-size: 1em;
        font-family: 'Railway', sans-serif;
        display: flex;
        align-items: center;
        gap: 4px;
        cursor: pointer;
        background-color: transparent;
        width: fit-content;
    }

    button:hover {
        background-color: #ffecee;
    }

</style>
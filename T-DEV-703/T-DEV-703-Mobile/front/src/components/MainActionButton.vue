<script lang="ts" setup>
import type { ButtonProps } from '@/types/button-props';
import { defineProps } from 'vue'

const props = defineProps<ButtonProps>()
const text = props.text
const onClick = props.onClick
const disable = props.disabled

</script>

<template>
  <button @click.prevent="onClick" :disabled="disable">
    <slot class="icon">
        <!-- Slot reserved for the icon. Exemple: <IconAdd /> -->
    </slot>
    {{ text }}
  </button>
</template>

<style scoped>

    button {
        padding: 0.7rem 1.2rem;
        font-size: 1.2em;
        border: none;
        border-radius: 0.5rem;
        margin-top: 0.5rem;
        background-color: #DE1628;
        color: #000;
        font-size: 1em;
        font-family: 'Railway', sans-serif;
        display: flex;
        align-items: center;
        gap: 4px;
        cursor: pointer;
        width: fit-content;
    }

    button:hover {
        background-color: #be1422;
    }

    button:disabled {
        background-color: #D3D3D3;
        color: #000;
    }
</style>
<script setup lang="ts">
import type { H1TitleProps } from '@/types/h1-title-props';
import { defineProps } from 'vue'

const props = defineProps<H1TitleProps>()

const title = props.text

</script>

<template>
  <h1>{{ title }}</h1>
</template>

<style scoped>
h1{
    font-size: 64px;
    font-family: 'Wendy One', serif;
    font-weight: 400;
    color: #000;
}
</style>
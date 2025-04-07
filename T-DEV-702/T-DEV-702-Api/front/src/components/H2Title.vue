<script setup lang="ts">
import type { H2TitleProps } from '@/types/h2-title-props'
import { IconDentistryOutline } from '@iconify-prerendered/vue-material-symbols';
import { defineProps } from 'vue'

const props = defineProps<H2TitleProps>()
const text = props.text
const fontSize = props.fontSize

</script>

<template>
  <h2>{{ text }} <IconDentistryOutline class="icon" color="#de2618" :font-size="fontSize" /> </h2>
</template>

<style scoped>
h2 {
    font-size: 1.5em;
    font-family: 'Montserrat Alternates', sans-serif;
    color: #000;
}

.icon {
  vertical-align: middle;
}
</style>
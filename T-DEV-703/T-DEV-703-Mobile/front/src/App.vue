<script setup lang="ts">
import { RouterView } from "vue-router";
import CustomHeader from "@/components/CustomHeader.vue";

import logo from "@/assets/logo.svg";
import CustomFooter from "./components/CustomFooter.vue";
</script>

<template>
  <CustomHeader :logo="logo" title="bite." />
  <RouterView />
  <CustomFooter />
</template>

<style scoped>
header {
  line-height: 1.5;
}

.logo {
  display: block;
  margin: 0 auto 2rem;
}

</style>

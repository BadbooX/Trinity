<script lang="ts" setup>
import { defineProps } from "vue";
import type { HeaderProps } from "@/types/header-props";
import { useJwtStore } from "@/stores/jwt";
import {
  IconAccountCircleOutline,
  IconLoginRounded,
  IconLogout,
  IconStoreOutlineRounded,
} from "@iconify-prerendered/vue-material-symbols";
import IconButton from "./IconButton.vue";
import { useRouter } from "vue-router";

const router = useRouter();
const props = defineProps<HeaderProps>();
const title = props.title;
const logo = props.logo;
const jwtStore = useJwtStore();

const logout = () => {
  jwtStore.setJwt('');
  router.push("/");
};

</script>

<template>
  <header>
    <div class="logo">
      <img :src="logo" alt="logo" @click="router.push('/')" />
      <p>{{ title }}</p>
    </div>
    <nav v-if="jwtStore.jwt">
      <IconButton text="account" :onClick="() => router.push(`/account`)">
        <IconAccountCircleOutline font-size="32px" />
      </IconButton>
      <IconButton text="home" :onClick="() => router.push('/home')">
        <IconStoreOutlineRounded font-size="32px" color="#de2618" />
      </IconButton>
      <IconButton text="logout" :onClick="logout">
        <IconLogout font-size="32px" />
      </IconButton>
    </nav>
    <nav v-else>
      <RouterLink to="/login" class="login">
        <IconLoginRounded />
        Sign in
      </RouterLink>
      <RouterLink to="/sign-up">
        <IconAccountCircleOutline class="icon" font-size="32px" color="#000" />
      </RouterLink>
    </nav>
  </header>
</template>

<style scoped>
header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background-color: #fff;
  color: #000;
  font-family: "Railway", sans-serif;
  box-shadow: 0px 4px 16px 4px rgba(0, 0, 0, 0.15);
  width: 100%;
}

.logo {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 1rem;
  padding: 1rem 2rem;
}

.logo img {
  width: 50px;
  height: 50px;
}

nav {
  display: flex;
  gap: 1rem;
  padding-right: 1rem;
}

.login {
  background-color: #de1628;
  padding: 0.5rem 1rem;
  border-radius: 8px;
  text-decoration: none;
  color: #000;
}

.login:hover {
  background-color: #be1422;
}

p {
  font-size: 0.9em;
  font-family: "Wendy One", sans-serif;
}

</style>

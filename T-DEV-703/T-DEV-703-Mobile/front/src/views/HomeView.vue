<script setup lang="ts">
import H1Title from "@/components/H1Title.vue";
import H2Title from "@/components/H2Title.vue";
import MainActionButton from "@/components/MainActionButton.vue";
import SecondaryButton from "@/components/SecondaryButton.vue";
import {
  IconAddReactionOutline,
  IconLoginRounded,
} from "@iconify-prerendered/vue-material-symbols";
import { useRouter } from "vue-router";

const router = useRouter();
</script>

<template>
  <main class="main">
    <img class="illu" src="@/assets/home-illu.svg" />
    <div class="column">
      <div class="row">
        <img class="logo" src="@/assets/logo.svg" />
        <H1Title text="bite." style="font-size: 86px" />
      </div>
      <H2Title
        class="h2"
        text="Take a bite in the good apple !"
        style="font-size: 48px; font-weight: 500"
        font-size="34px"
      />
      <div class="row">
        <SecondaryButton
          text="Sign up"
          :onClick="
            () => {
              router.push('/sign-up');
            }
          "
          style="font-size: 34px"
        >
          <IconAddReactionOutline font-size="34px" />
        </SecondaryButton>
        <MainActionButton
          class="button"
          text="Sign in"
          :onClick="
            () => {
              router.push('/login');
            }
          "
          style="font-size: 34px"
        >
          <IconLoginRounded font-size="34px" />
        </MainActionButton>
      </div>
    </div>
  </main>
</template>

<style scoped>
h2 {
  animation: heartbeat 3s;
}

@keyframes heartbeat {
  0% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.05);
  }
  100% {
    transform: scale(1);
  }
}

.main {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: center;
  gap: 3rem;
  width: 100%;
  flex-wrap: nowrap;
}

.row {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 0.5rem;
  flex-wrap: nowrap;
  height: fit-content;
  width: fit-content;
}

.column {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: flex-start;
  gap: 2rem;
  width: 34%;
}

img {
  vertical-align: middle;
}

.illu {
  width: 550px;
}

.logo {
  width: 100px;
}
</style>

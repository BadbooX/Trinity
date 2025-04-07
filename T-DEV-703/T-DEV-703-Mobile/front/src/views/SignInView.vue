<script lang="ts" setup>
import SignInForm from "@/components/forms/SignInForm.vue";
import H1Title from "@/components/H1Title.vue";
import H2Title from "@/components/H2Title.vue";
import InternalLink from "@/components/InternalLink.vue";
</script>

<template>
  <main>
    <div class="column">
      <div class="row">
        <img src="@/assets/logo.svg" />
        <H1Title text="Sign in" />
      </div>
      <H2Title text="Welcome back!" font-size="24px" />
      <SignInForm />
      <p>New here ? <InternalLink to="/sign-up" text="Click here!" /></p>
    </div>
  </main>
</template>

<style scoped>
.row {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 1rem;
  width: 100%;
}

img {
  width: 50px;
  height: 50px;
}

.column {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 1rem;
  margin: auto;
}
</style>

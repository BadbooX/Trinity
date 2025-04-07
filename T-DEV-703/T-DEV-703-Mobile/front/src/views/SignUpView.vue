<script lang="ts" setup>
import SignupForm from "@/components/forms/SignupForm.vue";
import H1Title from "@/components/H1Title.vue";
import H2Title from "@/components/H2Title.vue";
import InternalLink from "@/components/InternalLink.vue";
</script>

<template>
  <main>
    <div class="column">
      <div class="row">
        <img src="@/assets/logo.svg" />
        <H1Title text="Sign up" />
      </div>
        <H2Title text="Nice to meet you!" font-size="24px" />
      <SignupForm />
      <p>Already an account ? <InternalLink to="/login" text="Click here!" /> </p>
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
  margin: 2em auto 0 auto;
}
</style>

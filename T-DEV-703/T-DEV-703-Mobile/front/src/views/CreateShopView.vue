<script setup lang="ts">
import CreateShopForm from '@/components/forms/CreateShopForm.vue';
import H1Title from '@/components/H1Title.vue';
import H2Title from '@/components/H2Title.vue';

</script>

<template>
    <main>
        <div class="row">
            <img src="@/assets/logo.svg" />
            <H1Title text="Create a shop" />
        </div>
        <H2Title text="Fill the form to create your shop" font-size="24px" />
        <CreateShopForm />
    </main>
</template>

<style scoped>
    main {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        gap: 1rem;
        padding: 1rem;
    }
    
    .row{
        display: flex;
        align-items: center;
        gap: 1rem;
    }
    img {
        width: 50px;
        height: 50px;
    }

</style>
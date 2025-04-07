<script lang="ts" setup>
import AddProductForm from '@/components/forms/AddProductForm.vue';
import H1Title from '@/components/H1Title.vue';
import H2Title from '@/components/H2Title.vue';
import { useRouter } from 'vue-router';

const router = useRouter();
const id = router.currentRoute.value.params.id[0];

</script>

<template>
    <main>
        <div class="row">
            <img src="@/assets/logo.svg" />
            <H1Title text="Create a shop" />
        </div>
        <H2Title text="Fill the form to add your product" font-size="24px" />
        <AddProductForm :shop-id="id" />
    </main>
</template>

<style scoped>
img{
    width: 50px;
    height: 50px;
}

.row {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 1rem;
}

main {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 1rem;
    padding: 1rem;
}

</style>
<script lang="ts" setup>
import H1Title from '@/components/H1Title.vue';
import H2Title from '@/components/H2Title.vue';
import { useRoute } from 'vue-router';
import EditProductForm from '@/components/forms/EditProductForm.vue';


const productId = useRoute().params.productId[0];
const shopId = useRoute().params.shopId[0];

</script>

<template>
    <main>
        <div class="row">
            <img src="@/assets/logo.svg" />
            <H1Title text="Edit a product" />
        </div>
        <H2Title text="Fill the form to edit your product" font-size="24px" />
        <EditProductForm :product-id="productId.toString()" :shop-id="shopId"  />
    </main>
</template>

<style scoped>
    main {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        width: fit-content;
        gap: 2em;
        margin: 0 auto;
    }

    .row {
        display: flex;
        align-items: center;
        gap: 1em;
    }

    img{
        width: 50px;
        height: 50px;
    }
</style>
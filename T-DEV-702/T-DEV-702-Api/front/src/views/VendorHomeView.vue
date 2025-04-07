<script lang="ts" setup>
import H1Title from '@/components/H1Title.vue';
import H2Title from '@/components/H2Title.vue';
import ShopCard from '@/components/ShopCard.vue';
import { useShopStore } from '@/stores/shop';
import { IconAddBusinessOutlineRounded } from '@iconify-prerendered/vue-material-symbols-light';
import { useRouter } from 'vue-router';

const shopsStore = useShopStore();
const router = useRouter();

const shops = shopsStore.shops;

</script>

<template>
    <main id="main">
        <div class="row">
            <img src="@/assets/logo.svg" />
            <H1Title text="Select your shop" />
        </div>
        <H2Title text="Select the shop you want to manage" font-size="24px" />
        <div class="row-wrap">
            <ShopCard v-for="shop in shops" :key="shop.id" :name="shop.name" :id="shop.id" />
            <button type="button" @click="router.push('/create-shop')">
                <IconAddBusinessOutlineRounded font-size="84px" />
                <p>Create a shop</p>
            </button>
        </div>
    </main>
</template>

<style scoped>

#main {
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

.row-wrap {
    display: flex;
    flex-wrap: wrap;
    gap: 1rem;
    justify-content: center;
    align-items: center;
    width: 100%;
}

button {
    padding: 2em 3em;
    border-radius: 1em;
    background-color: #de2618;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    cursor: pointer;
}

p {
    font-size: 20px;
    font-family: "Montserrat Alternates", sans-serif;
    font-weight: 500;
    color: #000;
}

button:hover {
    background-color: #b21b11;
}
</style>
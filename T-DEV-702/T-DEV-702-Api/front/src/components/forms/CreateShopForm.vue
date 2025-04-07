<script lang="ts" setup>
import { useShopStore } from '@/stores/shop';
import { ref } from 'vue';
import CustomInput from '../CustomInput.vue';
import { IconAddBusinessOutlineRounded, IconBookmarkFlagOutlineRounded, IconLocationCityRounded, IconMarkunreadMailboxOutlineRounded, IconPaymentsOutlineRounded, IconSignpostOutlineRounded, IconStoreOutlineRounded } from '@iconify-prerendered/vue-material-symbols';
import { useRouter } from 'vue-router';
import MainActionButton from '../MainActionButton.vue';

const router = useRouter();
const shopStore = useShopStore();

const shop = ref({
    name: '',
    paypal: '',
    address: {
        street: '',
        city: '',
        postalCode: '',
        country: ''
    },
    id: '',
    owner: '3'
});
const error = ref('');
const success = ref(false);

const createShop = () => {
    if(shop.value.name === '' || shop.value.paypal === ''){
        error.value = 'Please fill all the fields';
        return;
    }
    try {
        shopStore.addShop(shop.value);
    } catch (e) {
        const err = e as Error;
        console.error(error);
        error.value = err.message;
    }
    success.value = true;
    router.push('/home')
}

</script>

<template>
    <form>
        <CustomInput type="text" v-model="shop.name" label="Shop name" placeholder="My greate shop">
            <IconStoreOutlineRounded color="#de2618" />
        </CustomInput>
        <CustomInput type="text" v-model="shop.paypal" label="Paypal ID" placeholder="example">
            <IconPaymentsOutlineRounded color="#de2618" />
        </CustomInput>
        <CustomInput type="text" v-model="shop.address.street" label="Street" placeholder="example">
            <IconSignpostOutlineRounded color="#de2618" />
        </CustomInput>
        <CustomInput type="text" v-model="shop.address.city" label="City" placeholder="example">
            <IconLocationCityRounded color="#de2618" />
        </CustomInput>
        <CustomInput type="text" v-model="shop.address.postalCode" label="Zip" placeholder="example">
            <IconMarkunreadMailboxOutlineRounded color="#de2618" />
        </CustomInput>
        <CustomInput type="text" v-model="shop.address.country" label="Country" placeholder="example">
            <IconBookmarkFlagOutlineRounded color="#de2618" />
        </CustomInput>
         <p v-if="error !== ''" class="error"> {{ error }}</p>
        <p class="succes" v-if="success">Shop created</p>
        <MainActionButton text="Create shop" :onClick="createShop">
            <IconAddBusinessOutlineRounded font-size="16px" />
        </MainActionButton>
    </form>
</template>

<style scoped>
    form {
        display: flex;
        flex-direction: column;
        gap: 1rem;
        width: 100%;
        max-width: 400px;
        margin: 0 auto;
    }
</style>
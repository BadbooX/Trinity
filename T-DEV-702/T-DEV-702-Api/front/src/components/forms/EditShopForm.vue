<script lang="ts" setup>
import { useShopStore } from '@/stores/shop';
import { useRouter } from 'vue-router';
import { IconAddBusinessOutlineRounded, IconBookmarkFlagOutlineRounded, IconLocationCityRounded, IconMarkunreadMailboxOutlineRounded, IconPaymentsOutlineRounded, IconSignpostOutlineRounded, IconStoreOutlineRounded } from '@iconify-prerendered/vue-material-symbols';
import CustomInput from '@/components/CustomInput.vue';
import MainActionButton from '@/components/MainActionButton.vue';
import { ref } from 'vue';


const router = useRouter();
const id = router.currentRoute.value.params['id'][0];

const shopStore = useShopStore();
const shop = shopStore.getShopById(id);
const error = ref('');
const success = ref(false);

const editShop = () => {
    if(!shop) {
        error.value = 'Shop not found';
        setTimeout(() => {
            router.push('/home');
        }, 2000);
        return;
    }
    if(shop?.name === '' || shop?.paypal === ''){
        error.value = 'Please fill all the fields';
        return;
    }
    try {
        shopStore.editShop(id, {name: shop!.name, id: id, owner: shop!.owner, paypal: shop!.paypal, address: {
            city: shop.address.city,
            country: shop.address.country,
            postalCode: shop.address.postalCode,
            street: shop.address.street
        }});
    } catch (e) {
        const err = e as Error;
        console.error(error);
        error.value = err.message;
    }
    success.value = true;
    setTimeout(() => {
        router.push('/home');
    }, 2000);
}

</script>

<template>
    <form>
        <CustomInput type="text" v-model="shop!.name" label="Shop name" placeholder="My greate shop">
            <IconStoreOutlineRounded color="#de2618" />
        </CustomInput>
        <CustomInput type="text" v-model="shop!.paypal" label="Paypal ID" placeholder="example">
            <IconPaymentsOutlineRounded color="#de2618" />
        </CustomInput>
        <CustomInput type="text" v-model="shop!.address.street" label="Street" placeholder="example">
            <IconSignpostOutlineRounded color="#de2618" />
        </CustomInput>
        <CustomInput type="text" v-model="shop!.address.city" label="City" placeholder="example">
            <IconLocationCityRounded color="#de2618" />
        </CustomInput>
        <CustomInput type="text" v-model="shop!.address.postalCode" label="Zip" placeholder="example">
            <IconMarkunreadMailboxOutlineRounded color="#de2618" />
        </CustomInput>
        <CustomInput type="text" v-model="shop!.address.country" label="Country" placeholder="example">
            <IconBookmarkFlagOutlineRounded color="#de2618" />
        </CustomInput>
        <p v-if="error !== ''" class="error"> {{ error }}</p>
        <p class="success" v-if="success">Shop modified</p>
        <MainActionButton text="Edit shop" :onClick="editShop">
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
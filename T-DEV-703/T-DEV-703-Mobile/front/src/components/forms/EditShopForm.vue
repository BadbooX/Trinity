<script lang="ts" setup>
import { ref, onMounted } from 'vue';
import type { Shop } from '@/types/shop';
import { useRouter, useRoute } from 'vue-router';
import { useShopStore } from '@/stores/shop';
import CustomInput from '@/components/CustomInput.vue';
import MainActionButton from '@/components/MainActionButton.vue';
import { IconStoreOutlineRounded, IconPaymentsOutlineRounded, IconSignpostOutlineRounded, IconLocationCityRounded, IconMarkunreadMailboxOutlineRounded, IconBookmarkFlagOutlineRounded, IconPhoneCallbackOutline } from '@iconify-prerendered/vue-material-symbols';

const router = useRouter();
const route = useRoute();
const shopStore = useShopStore();

const shop = ref<Shop | null>(null);
const error = ref('');
const success = ref(false);

const id = Number(route.params.id); // Convert id to a number

const handleSubmit = async () => {
    if (!shop.value || !shop.value.name || !shop.value.idPaypal || !shop.value.address.street || !shop.value.address.city || !shop.value.address.postalCode) {
        error.value = 'Please fill all fields';
        return;
    }
    try {
        await shopStore.editShop(id.toString(), shop.value);
        success.value = true;
        setTimeout(() => {
            router.push('/home');
        }, 2000);
    } catch (err) {
        const e = err as Error;
        error.value = e.message;
    }
};

onMounted(() => {
    const fetchedShop = shopStore.shops.find(s => s.id.toString() === id.toString());
    if (fetchedShop) {
        shop.value = {
            id: fetchedShop.id,
            name: fetchedShop.name,
            sellerId: fetchedShop.sellerId,
            idPaypal: fetchedShop.idPaypal,
            phoneNumber: fetchedShop.phoneNumber,
            address: {
                street: fetchedShop.address.street,
                city: fetchedShop.address.city,
                postalCode: fetchedShop.address.postalCode,
                country: fetchedShop.address.country
            }
        };
    } else {
        error.value = 'Shop not found';
    }
});
</script>

<template>
    <form v-if="shop">
        <CustomInput type="text" v-model="shop.name" label="Shop name" placeholder="My great shop">
            <IconStoreOutlineRounded color="#de2618" />
        </CustomInput>
        <CustomInput type="phone" v-model="shop.phoneNumber" label="Phone" placeholder="123456789">
            <IconPhoneCallbackOutline color="#de2618" />
        </CustomInput>
        <CustomInput type="text" v-model="shop.idPaypal" label="Paypal ID" placeholder="example">
            <IconPaymentsOutlineRounded color="#de2618" />
        </CustomInput>
        <CustomInput type="text" v-model="shop.address.street" label="Street" placeholder="123 Main St">
            <IconSignpostOutlineRounded color="#de2618" />
        </CustomInput>
        <CustomInput type="text" v-model="shop.address.city" label="City" placeholder="New York">
            <IconLocationCityRounded color="#de2618" />
        </CustomInput>
        <CustomInput type="text" v-model="shop.address.postalCode" label="Zip" placeholder="12345">
            <IconMarkunreadMailboxOutlineRounded color="#de2618" />
        </CustomInput>
        <CustomInput type="text" v-model="shop.address.country" label="Country" placeholder="USA">
            <IconLocationCityRounded color="#de2618" />
        </CustomInput>
        <MainActionButton text="Save" type="button" :onClick="handleSubmit">
            <IconBookmarkFlagOutlineRounded font-size="24px" />
        </MainActionButton>
        <p v-if="error" class="error">{{ error }}</p>
        <p v-if="success" class="success">Shop updated successfully!</p>
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
.error {
    color: red;
}
.success {
    color: green;
}
</style>
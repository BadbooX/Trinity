<script lang="ts" setup>

import CustomInput from '../CustomInput.vue';
import { IconBarcode, IconEdit, IconProductionQuantityLimits, IconShoppingmodeOutline, IconSignatureRounded } from '@iconify-prerendered/vue-material-symbols';
import MainActionButton from '../MainActionButton.vue';
import { useProductStore } from '@/stores/product';
import { onMounted, ref } from 'vue';
import InternalLink from '../InternalLink.vue';
import type { Product } from '@/types/product';

const props = defineProps<{
    shopId: string;
    productId: string;
}>();

const error = ref('')
const success = ref(false)

const productsStore = useProductStore();
const fetchedProduct = productsStore.products.find(p => p.id!.toString() === props.productId);
const product = ref<Product>(fetchedProduct ? fetchedProduct : {name: '', barCode: '', stock: 0, price: 0})


const editProduct = () => {
    if(product!.value!.name === '' || product.value!.barCode === '' || product.value!.stock === 0 || product.value!.price === 0){
        error.value = 'Please fill all the fields'
        return
    }
    try{
        if(!product.value) return
        if(!product.value.id) return
        productsStore.editProduct(parseInt(props.productId), product.value)
    } catch (e) {
        const err = e as Error
        error.value = err.message
        return
    }
    success.value = true
}

onMounted( () => {
    const fetchedProduct = productsStore.products.find(p => p.id!.toString() === props.productId);
    if(fetchedProduct) {
        product.value.name = fetchedProduct.name
        product.value.barCode = fetchedProduct.barCode
        product.value.stock = fetchedProduct.stock
        product.value.price = fetchedProduct.price
        product.value.id = fetchedProduct.id
    }
});

</script>


<template>
    <form v-if="product" > 
        <CustomInput label="Name" v-model="product!.name" placeholder="Cereals" type="text">
            <IconSignatureRounded color="#de2618" font-size="16px" />
        </CustomInput>
        <CustomInput type="text" v-model="product!.barCode" placeholder="123456789" label="Code barre">
            <IconBarcode color="#de2618" font-size="16px" />
        </CustomInput>
        <CustomInput type="number" v-model="product!.stock" placeholder="10" label="Quantity">
            <IconProductionQuantityLimits color="#de2618" font-size="16px" />
        </CustomInput>
        <CustomInput type="number" v-model="product!.price" placeholder="10" label="Price">
            <IconShoppingmodeOutline color="#de2618" font-size="16px" />
        </CustomInput>
        <MainActionButton :onClick="editProduct" text="Change product">
            <IconEdit font-size="18px" />
        </MainActionButton>
        <p> </p>
        <p v-if="success">Product changed ! <InternalLink text="Go back to shop page" :to="`/shop/${props.shopId}`" /> </p>
    </form>
</template>

<style scoped>

</style>
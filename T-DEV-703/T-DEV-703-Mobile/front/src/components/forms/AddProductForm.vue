<script lang="ts" setup>
import CustomInput from '../CustomInput.vue'
import {
  IconAdd,
  IconBarcode,
  IconProductionQuantityLimits,
  IconShoppingmodeOutline,
  IconSignatureRounded,
} from '@iconify-prerendered/vue-material-symbols'
import MainActionButton from '../MainActionButton.vue'
import { useProductStore } from '@/stores/product'
import { ref } from 'vue'
import InternalLink from '../InternalLink.vue'

const props = defineProps<{
  shopId: string
}>()

const product = {
  name: '',
  barCode: '',
  stock: 0,
  price: 0,
  priceTVA: 0,
  priceTTC: 0,
  priceHT: 0,
}
const error = ref('')
const success = ref(false)

const productsStore = useProductStore()

const addProduct = () => {
  if (
    product.name === '' ||
    product.barCode === '' ||
    product.stock === 0 ||
    product.priceTVA === 0 ||
    product.priceTTC === 0 ||
    product.priceHT === 0
  ) {
    error.value = 'Please fill all the fields'
    return
  }
  try {
    productsStore.addProduct(props.shopId, product)
  } catch (e) {
    const err = e as Error
    error.value = err.message
    return
  }
  success.value = true
}
</script>

<template>
  <form>
    <CustomInput label="Name" v-model="product.name" placeholder="Cereals" type="text">
      <IconSignatureRounded color="#de2618" font-size="16px" />
    </CustomInput>
    <CustomInput type="text" v-model="product.barCode" placeholder="123456789" label="Code barre">
      <IconBarcode color="#de2618" font-size="16px" />
    </CustomInput>
    <CustomInput type="number" v-model="product.stock" placeholder="10" label="Quantity">
      <IconProductionQuantityLimits color="#de2618" font-size="16px" />
    </CustomInput>
    <CustomInput type="number" v-model="product.priceHT" placeholder="10" label="Price HT">
      <IconShoppingmodeOutline color="#de2618" font-size="16px" />
    </CustomInput>
    <CustomInput type="number" v-model="product.priceTVA" placeholder="10" label="Price TVA">
      <IconShoppingmodeOutline color="#de2618" font-size="16px" />
    </CustomInput>
    <CustomInput type="number" v-model="product.priceTTC" placeholder="10" label="Price TTC">
      <IconShoppingmodeOutline color="#de2618" font-size="16px" />
    </CustomInput>
    <MainActionButton :onClick="addProduct" text="Add product">
      <IconAdd font-size="18px" />
    </MainActionButton>
    <p v-if="error">{{ error }}</p>
    <p v-if="success">
      Product added ! <InternalLink text="Go back to shop page" :to="`/shop/${props.shopId}`" />
    </p>
  </form>
</template>

<style scoped></style>

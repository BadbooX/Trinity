import type { Product } from '@/types/product'
import { defineStore } from 'pinia'
import { ref } from 'vue'
import { useJwtStore } from './jwt'

export const useProductStore = defineStore(
  'product',
  () => {
    const products = ref<Product[]>([])
    const jwtStore = useJwtStore()

    const fetchProducts = async (shopId: string) => {
      const response = await fetch(`https://localhost:3000/api/products/shops/${shopId}`, {
        headers: {
          Authorization: `Bearer ${jwtStore.jwt}`,
        },
      })
      const data = await response.json()
      products.value = data
      console.log(products.value)
    }

    const getProductById = async (id: number) => {
      let product = products.value.find((product) => product.id === id)
      if (!product) {
        return
      }
      console.log(product)
      const res = await fetchOpenFoodFacts(product.barCode!)
      product = { ...product, ...res.product }
      return product
    }

    const addProduct = async (
      shopId: string,
      product: {
        name: string
        barCode: string
        priceTTC: number
        priceHT: number
        priceTVA: number
        stock: number
      },
    ) => {
      const res = await fetch(`https://localhost:3000/api/products/shops/${shopId}`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${jwtStore.jwt}`,
        },
        body: JSON.stringify(product),
      })
      if (res.status === 401) {
        throw new Error('Unauthorized')
      }
      if (res.status === 403) {
        throw new Error('Forbidden')
      }
      if (res.status === 400) {
        throw new Error('Missing parameters')
      }
      if (res.status === 500) {
        throw new Error('Internal Server Error')
      }
      await fetchProducts(shopId)
      return true
    }

    const removeProduct = async (id: number) => {
      const index = products.value.findIndex((product) => product.id === id)
      const res = await fetch(`https://localhost:3000/api/products/${id}`, {
        method: 'DELETE',
        headers: {
          Authorization: `Bearer ${jwtStore.jwt}`,
        },
      })
      if (res.status === 401) {
        throw new Error('Unauthorized')
      }
      if (res.status === 403) {
        throw new Error('Forbidden')
      }
      if (res.status === 404) {
        throw new Error('Product not found')
      }
      if (res.status === 500) {
        throw new Error('Internal Server Error')
      }
      products.value.splice(index, 1)
    }

    const editProduct = async (
      id: number,
      product: { id?: number; name?: string; barCode?: string; price?: number; stock?: number },
    ) => {
      if (!product.id) {
        return
      }
      const index = products.value.findIndex((product) => product.id === id)
      const res = await fetch(`https://localhost:3000/api/products/${id}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${jwtStore.jwt}`,
        },
        body: JSON.stringify(product),
      })
      if (res.status === 401) {
        throw new Error('Unauthorized')
      }
      if (res.status === 403) {
        throw new Error('Forbidden')
      }
      if (res.status === 404) {
        throw new Error('Product not found')
      }
      if (res.status === 500) {
        throw new Error('Internal Server Error')
      }
      products.value[index] = product
    }

    const fetchOpenFoodFacts = async (barCode: string) => {
      const response = await fetch(`https://world.openfoodfacts.org/api/v2/product/${barCode}.json`)
      const data = await response.json()
      return data
    }

    return {
      products,
      getProductById,
      addProduct,
      removeProduct,
      editProduct,
      fetchProducts,
      fetchOpenFoodFacts,
    }
  },
  {
    persist: true,
  },
)

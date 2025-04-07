import { defineStore } from 'pinia'
import { ref } from 'vue'
import type { Shop } from '@/types/shop'
import { useJwtStore } from './jwt'
import { useUserStore } from './user'

export const useShopStore = defineStore(
  'shop',
  () => {
    const shops = ref<Shop[]>([])
    const jwtStore = useJwtStore()
    const userStore = useUserStore()

    const fetchShops = async () => {
      const res = await fetch('https://localhost:3000/api/shops/my', {
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${jwtStore.jwt}`,
        },
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
      const data = await res.json()
      shops.value = data
    }

    const getShopById = async (id: string) => {
      return shops.value.find((shop) => shop.id === id)
    }

    const addShop = async (shop: {
      name: string
      id: string
      owner: string
      paypal: string
      address: { city: string; postalCode: string; street: string; country: string }
    }) => {
      await fetch('https://localhost:3000/api/shops', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${jwtStore.jwt}`,
        },
        body: JSON.stringify({
          phoneNumber: userStore.user.phoneNumber,
          sellerId: userStore.user.id,
          email: userStore.user.email,
          name: shop.name,
          idPaypal: shop.paypal,
          address: {
            country: shop.address.country,
            city: shop.address.city,
            postalCode: parseInt(shop.address.postalCode),
            street: shop.address.street,
          },
        }),
      }).then((res) => {
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
        return res.json()
      })
      await fetchShops()
      return true
    }

    const removeShop = async (id: string) => {
      const res = await fetch(`https://localhost:3000/api/shops/${id}`, {
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
      if (res.status === 400) {
        throw new Error('Missing parameters')
      }
      if (res.status === 404) {
        throw new Error('Shop not found')
      }
      if (res.status === 500) {
        throw new Error('Internal Server Error')
      }
      await fetchShops()
      return true
    }

    const editShop = async (
      id: string,
      shop: {
        name: string
        sellerId: string
        id: string
        idPaypal: string
        address: { city: string; postalCode: string; country: string; street: string }
      },
    ) => {
      const res = await fetch(`https://localhost:3000/api/shops/${id}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${jwtStore.jwt}`,
        },
        body: JSON.stringify(shop),
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
      if (res.status === 404) {
        throw new Error('Shop not found')
      }
      if (res.status === 500) {
        throw new Error('Internal Server Error')
      }
      await fetchShops()
      return true
    }
    return { shops, getShopById, addShop, removeShop, editShop, fetchShops }
  },
  {
    persist: true,
  },
)

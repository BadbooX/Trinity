import type { Address } from "@/types/address";
import { defineStore } from "pinia";
import { ref } from "vue";

export const useShopStore = defineStore('shop', () => {
    const shops = ref([
        {
            name: 'Shop 1', 
            id: '1', 
            owner: '1', 
            paypal: 'paypal.me/shop1', 
            address: {
                street: 'Street 1',
                city: 'City 1',
                postalCode: 'Zip 1',
                country: 'Country 1'
        }},
        {
            name: 'Shop 2',
            id: '2', 
            owner: '2', 
            paypal: 'paypal.me/shop2',
            address: {
                street: 'Street 2',
                city: 'City 2',
                postalCode: 'Zip 2',
                country: 'Country 2'
        }},
    ]);

    const getShopById = (id: string) => {
        console.log(shops.value.find(shop => shop.id === id));
        return shops.value.find(shop => shop.id === id);
    }

    const addShop = (shop: {name: string, id: string, owner :string, paypal :string, address :Address}) => {
        const id = shops.value.length + 1;
        shop.id = id.toString();
        shop.owner = '3';
        shops.value.push(shop);
    }   

    const removeShop = (id: string) => {
        const index = shops.value.findIndex(shop => shop.id === id);
        shops.value.splice(index, 1);
    }

    const editShop = (id: string, shop: {name: string, owner: string, id: string, paypal :string, address: Address}) => {
        const index = shops.value.findIndex(shop => shop.id === id);
        shops.value[index] = shop;
    }

    return { shops, getShopById, addShop, removeShop, editShop }
    }, 
    {
        persist: true,
    }
);
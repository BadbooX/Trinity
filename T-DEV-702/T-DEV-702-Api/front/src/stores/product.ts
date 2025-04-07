import { defineStore } from "pinia";
import { ref } from "vue";

export const useProductStore = defineStore('product', () => {
    const products = ref([
        {name: 'Product 1', code: '737628064502', id: '1', price: '100', description: 'Description 1', quantity: 10},
        {name: 'Product 2', code: '8000500309469', id: '2', price: '200', description: 'Description 2', quantity: 20},
    ]);

    const getProductById = (id: string) => {
        return products.value.find(product => product.id === id);
    }

    const addProduct = (product: {name: string, id: string, code: string, price: string, description: string, image: string, quantity: number, shopId: string}) => {
        const id = products.value.length + 1;
        product.id = id.toString();
        products.value.push(product);
    }

    const removeProduct = (id: string) => {
        const index = products.value.findIndex(product => product.id === id);
        products.value.splice(index, 1);
    }

    const editProduct = (id: string, product: {id: string, name: string, code: string, price: string, description: string, image: string, quantity: number, shopId: string}) => {
        const index = products.value.findIndex(product => product.id === id);
        products.value[index] = product;
    }

    return { products, getProductById, addProduct, removeProduct, editProduct }
    },
    {
        persist: true,
    }
);
<script setup lang="ts">
import H1Title from "@/components/H1Title.vue";
import H2Title from "@/components/H2Title.vue";
import MainActionButton from "@/components/MainActionButton.vue";
import ProductsTable from "@/components/ProductsTable.vue";
import SecondaryButton from "@/components/SecondaryButton.vue";
import { useProductStore } from "@/stores/product";
import { useShopStore } from "@/stores/shop";
import type { Product } from "@/types/product";
import type { Shop } from "@/types/shop";
import {
    IconBarChart4Bars,
  IconGrocery,
  IconSortByAlphaRounded,
} from "@iconify-prerendered/vue-material-symbols";
import { onMounted, ref } from "vue";
import { useRouter } from "vue-router";

const shopStore = useShopStore();
const productsStore = useProductStore();
const router = useRouter();
const id = router.currentRoute.value.params.id[0];
const shop = ref<Shop>();
const products = ref<Product[]>([]);
const orderByOptions = [
  {
    value: "name-asc",
    display: "Name A-Z",
  },
  {
    value: "name-desc",
    display: "Name Z-A",
  },
  {
    value: "price-asc",
    display: "Price ascending",
  },
  {
    value: "price-desc",
    display: "Price descending",
  },
  {
    value: "quantity-asc",
    display: "Quantity ascending",
  },
  {
    value: "quantity-desc",
    display: "Quantity descending",
  },
];

onMounted(async () => {
  const fetchedShop = shopStore.shops.find((s) => s.id.toString() === id.toString());
  if (fetchedShop) {
    shop.value = fetchedShop;
  } else {
    router.push({ name: "Home" });
  }
  await productsStore.fetchProducts(id);
  products.value = productsStore.products;
  if (!shop.value) {
    router.push({ name: "Home" });
  }
});

const selectedOrderOption = ref("default");
const orderProducts = () => {
  if (selectedOrderOption.value === "default") {
    products.value = productsStore.products;
  } else {
    console.log(selectedOrderOption.value);
    const [field, order] = selectedOrderOption.value.split("-") as [
      keyof Product,
      "asc" | "desc"
    ];
    products.value = productsStore.products.sort((a, b) => {
      if (order === "asc") {
        return (a[field] ?? "") > (b[field] ?? "") ? 1 : -1;
      } else {
        return (a[field] ?? "") < (b[field] ?? "") ? 1 : -1;
      }
    });
  }
};
</script>

<template>
  <div class="column" v-if="shop">
    <H1Title :text="`Shop ${shop!.name}`" />
    <H2Title text="Your products" font-size="24px" />
    <div class="row">
        <MainActionButton
      text="add a product"
      :onClick="
        () => {
          router.push(`/shop/${id}/add-product`);
        }
      "
    >
      <IconGrocery font-size="24px" />
    </MainActionButton>
    <SecondaryButton text="See shop performance" :onClick="() => router.push(`/shop/${id}/kpi`)">
        <IconBarChart4Bars font-size="24px"/>
    </SecondaryButton>
    </div>
    <div class="table">
      <div class="order-by">
        <IconSortByAlphaRounded color="#000" font-size="18px" />
        <select v-model="selectedOrderOption" @change="orderProducts">
          <option value="default">Order-by</option>
          <option
            :key="option.value"
            v-for="option in orderByOptions"
            :value="option.value"
          >
            {{ option.display }}
          </option>
        </select>
      </div>
      <ProductsTable :shop-id="id" :products="products" />
    </div>
  </div>
  <div v-else class="column">
    <p>LOADING...</p>
  </div>
</template>

<style scoped>
.column {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  margin-top: 20px;
  gap: 2em;
  height: 78vh;
}
.table {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 0.5em;
  width: fit-content;
}

.row{
    display: flex;
    flex-direction: row;
    align-items: center;
    justify-content: center;
    gap: 1em;
}

.order-by {
  display: flex;
  flex-direction: row;
  align-self: flex-end;
  align-items: center;
  justify-content: center;
  background-color: #F7ECED;
  padding: 0.5em;
  border-radius: 5px;
}

select {
  width: fit-content;
  background-color: transparent;
  border: none;
}

option{
    background-color: #F7ECED;
}
</style>

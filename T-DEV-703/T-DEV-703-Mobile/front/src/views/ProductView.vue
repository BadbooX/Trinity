<script lang="ts" setup>
import H1Title from "@/components/H1Title.vue";
import IconButton from "@/components/IconButton.vue";
import InternalLink from "@/components/InternalLink.vue";
import { useProductStore } from "@/stores/product";
import type { Product } from "@/types/product";
import {
  IconArrowBack,
  IconDeleteForeverOutlineRounded,
  IconEditOutline,
} from "@iconify-prerendered/vue-material-symbols";
import { onMounted, ref } from "vue";
import { useRouter } from "vue-router";

const router = useRouter();
const shopId = router.currentRoute.value.params.shopId[0];
const productId = router.currentRoute.value.params.productId[0];
const productsStore = useProductStore();
const product = ref<Product>();
const isLoading = ref(false);
const nutriSrc = ref<string>();
const novaGroupSrc = ref<string>();
const novaDescription = [
  {
    id: 1,
    description: "Unprocessed or minimally processed foods",
  },
  {
    id: 2,
    description: "Processed culinary ingredients",
  },
  {
    id: 3,
    description: "Processed foods",
  },
  {
    id: 4,
    description: "Ultra-processed food and drink products",
  },
];

const deleteProduct = async (id: number) => {
  const conf = confirm(`Are you sure you want to delete ${product.value?.name}?`);
  if(!conf) return;
  await productsStore.removeProduct(id);
  router.push(`/shop/${shopId}`);
};

onMounted(async () => {
  isLoading.value = true;
  product.value = await productsStore.getProductById(parseInt(productId));
  nutriSrc.value = `@/assets/nutri-${product.value!.nutriscore_grade}.png`;
  novaGroupSrc.value = `@/assets/novas${product.value!.nova_group}.png`;
  isLoading.value = false;
});

</script>

<template>
  <main v-if="isLoading">
    <p>LOADING...</p>
  </main>

  <main v-else-if="product">
    <IconButton text="back" :onClick="() => router.push(`/shop/${shopId}`)">
      <IconArrowBack font-size="24px" />
    </IconButton>
    <H1Title :text="product.name!" />
    <div class="row">
      <IconButton text="delete"  :onClick="() => deleteProduct(parseInt(productId))">
        <IconDeleteForeverOutlineRounded font-size="34px" color="#de2618" />
      </IconButton>
      <IconButton text="edit" :onClick="() => router.push(`/shop/${shopId}/edit-prodduct/${productId}`)">
        <IconEditOutline font-size="34px" />
      </IconButton>
    </div>
    <div class="row infos">
      <img
        v-if="!isLoading"
        :src="product.image ?? product.image_front_url"
        alt="product image"
        class="product-img"
      />
      <div class="column">
        <p><span class="bold underline">Brand:</span> {{ product.brands }}</p>
        <p><span class="bold underline">Code:</span> {{ product.code }}</p>
        <p>
          <span class="bold underline">Ingredients: </span>
          {{ product.ingredients_text_en }}
        </p>
        <p>
          <span class="bold underline">Allergens: </span>
          {{ product.allergens_from_ingredients }}
        </p>
        <p><span class="bold underline">Price:</span> {{ product.price }}€</p>
        <p>
          <span class="bold underline">Quantity in stock:</span>
          {{ product.stock?.toString() }}
        </p>
        <div class="nutri">
          <p><span class="bold underline">Nutritional infos</span></p>
          <p>
            <span class="italic">Portion size:</span>
            {{ product.serving_quantity ?? "no quantity"
            }}{{ product.serving_quantity_unit }}
          </p>
          <p v-if="product.energy_serving && product.energy_unit">
            <span class="italic">Energy:</span> {{ product.energy_serving
            }}{{ product.energy_unit }}
          </p>
          <table>
            <thead>
              <tr>
                <th class="bold">Nutrient</th>
                <th class="bold">Level</th>
              </tr>
            </thead>
            <tbody>
              <tr :class="product.nutrient_levels?.fat">
                <td>Fat</td>
                <td>{{ product.nutrient_levels?.fat }}</td>
              </tr>
              <tr :class="product.nutrient_levels?.salt">
                <td>Salt</td>
                <td>{{ product.nutrient_levels?.salt }}</td>
              </tr>
              <tr :class="product.nutrient_levels?.['saturated-fat']">
                <td>Saturated Fat</td>
                <td>{{ product.nutrient_levels?.["saturated-fat"] }}</td>
              </tr>
              <tr :class="product.nutrient_levels?.sugars">
                <td>Sugars</td>
                <td>{{ product.nutrient_levels?.sugars }}</td>
              </tr>
            </tbody>
          </table>
          <div class="row imgs">
            <img class="score" :src="`/nutri-${product.nutriscore_grade}.png`" />
            <div v-if="product.nova_group">
              <img class="score" :src="`/nova${product.nova_group}.png`" />
              <span :class="'nova' + product.nova_group + ' bold'">
                {{ novaDescription[product?.nova_group - 1].description }}
              </span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </main>

  <main v-else>
    <H1Title text="Product not found" />
    <InternalLink text="Go back" :to="`/shop/${shopId}`" />
  </main>
</template>

<style scoped>
main {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-height: 80vh;
  gap: 1rem;
  padding: 1rem;
  max-width: 60%;
  margin: 0 auto;
}

.row {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: center;
  gap: 1.5rem;
}

.infos {
  align-items: flex-start;
}

.product-img {
  height: 350px;
}

.score {
  height: 55px;
  margin: 0 1rem;
}

.imgs {
  justify-content: flex-start;
}

.nova1 {
  color: rgb(5, 150, 95);
}

.nova2 {
  color: orange;
}

.nova3 {
  color: #de5a18;
}

.nova4 {
  color: #de2618;
}

table {
  width: 100%;
  border-collapse: collapse;
}

th {
  text-align: left;
}

.moderate {
  background-color: #ffe7db;
}

.low {
  background-color: #b2d8b2;
}

.high {
  background-color: #f0b2b2;
}

.nutri {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.column {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}
</style>

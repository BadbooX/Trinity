<script lang="ts" setup>
import IconButton from "@/components/IconButton.vue";
import { useProductStore } from "@/stores/product";
import type { Product } from "@/types/product";
import {
  IconDeleteOutlineRounded,
  IconEditOutlineRounded,
  IconVisibilityOutline,
} from "@iconify-prerendered/vue-material-symbols";
import { ref } from "vue";
import { useRouter } from "vue-router";

const router = useRouter();
const error = ref("");
const props = defineProps<{
  shopId: string;
  products: Array<Product>;
}>();
const productsStore = useProductStore();

const deleteProduct = async (id: number) => {
  const conf = confirm("Are you sure you want to delete this product?");
  if (!conf) return;
  try {
    await productsStore.removeProduct(id);
  }
  catch (err) {
    const e = err as Error;
    error.value = e.message;
  }
};

</script>

<template>
  <table>
  <p class="error" v-if="error !== ''">{{ error }}</p>
    <thead>
      <tr>
        <th>Nom</th>
        <th>Code barre</th>
        <th>Quantité en stock</th>
        <th>Prix</th>
        <th>Actions</th>
      </tr>
    </thead>
    <tbody>
      <tr v-for="product in props.products" :key="product.id">
        <td>{{ product.name }}</td>
        <td>{{ product.barCode }}</td>
        <td>{{ product.stock }}</td>
        <td>{{ product.price }}</td>
        <td class="row">
          <IconButton
            text="see product"
            :onClick="() => router.push(`/shop/${shopId}/products/${product.id}`)"
          >
            <IconVisibilityOutline font-size="24px" />
          </IconButton>
          <IconButton text="edit" :onClick="() => router.push(`/shop/${shopId}/edit-product/${product.id}`)">
            <IconEditOutlineRounded font-size="24px" />
          </IconButton>
          <IconButton text="delete" :onClick="() => deleteProduct(product.id!)">
            <IconDeleteOutlineRounded font-size="24px" color="#de1628" />
          </IconButton>
        </td>
      </tr>
    </tbody>
  </table>
</template>

<style scoped>
table {
  width: fit-content;
  border-collapse: collapse;
  text-align: left;
}

.row {
  display: flex;
  align-items: center;
  justify-content: flex-start;
}

th,
td {
  border-right: 2px solid black;
  padding: 0.5em 1em;
  text-align: left;
}

th {
  font-family: "Montserrat Alternates", sans-serif;
  font-weight: 600;
}
</style>

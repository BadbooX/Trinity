<script lang="ts" setup>
import { useShopStore } from "@/stores/shop";
import type { ShopProps } from "@/types/shop-props";
import {
  IconClose,
  IconEditOutlineRounded,
} from "@iconify-prerendered/vue-material-symbols";
import { IconStoreOutlineRounded } from "@iconify-prerendered/vue-material-symbols-light";
import { useRouter } from "vue-router";

const router = useRouter();
const props = defineProps<ShopProps>();
const name = props.name;
const id = props.id;
const shopStore = useShopStore();

const deleteStore = () => {
  const conf = confirm("Are you sure you want to delete this shop ?");

  if (conf) {
    shopStore.removeShop(id);
    window.location.reload();
  }
};
</script>

<template>
  <div class="card">
    <div class="icons">
      <IconClose class="icon" @click="deleteStore" />
      <IconEditOutlineRounded class="icon" @click="router.push(`/edit-shop/${id}`)" />
    </div>
    <div class="card-col" @click="router.push(`/shop/${id}`)">
      <IconStoreOutlineRounded font-size="84px" weight="100" color="#de2618" />
      <p>{{ name }}</p>
    </div>
  </div>
</template>

<style scoped>
.card {
  background-color: #ffced3;
  padding: 1em 2em;
  border-radius: 1em;
  position: relative;
  max-width: 250px;
}

.card-col {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  cursor: pointer;
}

.icons {
  display: flex;
  justify-content: flex-end;
  align-items: center;
  width: max-content;
  cursor: pointer;
}

.icon:hover {
  color: #de2618;
}

p {
  font-size: 24px;
  font-family: "Montserrat Alternates", sans-serif;
  font-weight: 500;
  max-width: 250px;
  max-lines: 3;
}

.card:hover {
  background-color: #e8b3b8;
}
</style>

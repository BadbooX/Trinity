<script lang="ts" setup>
import H1Title from "@/components/H1Title.vue";
import H2Title from "@/components/H2Title.vue";
import IconButton from "@/components/IconButton.vue";
import { useShopStore } from "@/stores/shop";
import type { Shop } from "@/types/shop";
import { onMounted, ref } from "vue";
import { useRouter } from "vue-router";
import data from "@/data.json";
import {
  IconMoving,
  IconPersonRaisedHandOutline,
  IconSellOutline,
  IconSouthEast,
} from "@iconify-prerendered/vue-material-symbols";
import { Bar, Line, Pie } from "vue-chartjs";
import {
  Chart as ChartJS,
  Title,
  Tooltip,
  Legend,
  BarElement,
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  ArcElement
} from 'chart.js';

ChartJS.register(
  Title,
  Tooltip,
  Legend,
  BarElement,
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  ArcElement
);

const router = useRouter();
const shopId = router.currentRoute.value.params.shopId[0];
const shop = ref<Shop>();
const shopStore = useShopStore();
const currentYear = new Date().getFullYear();

const busyHours = {
  labels: data.busyPeriods.map(period => period.hour),
  datasets: [
    {
      label: 'Sales',
      data: data.busyPeriods.map(period => period.sales),
      backgroundColor: '#de2618',
    },
  ],
};

const salesEvolution = {
    labels: data.monthlyIncome.map(month => month.month),
    datasets: [
        {
            label: 'Sales',
            data: data.monthlyIncome.map(month => month.income),
            backgroundColor: '#de2618',
        },
    ],
}

const productPopularity = {
    labels: data.topProducts.map(product => product.product),
    datasets: [
        {
            label: 'Top 10 products',
            data: data.topProducts.map(product => product.sales),
            backgroundColor: '#de2618',
        },
    ]
}

onMounted(() => {
  shop.value = shopStore.shops.find((s) => s.id.toString() === shopId);
});
</script>

<template>
  <main v-if="shop">
    <div class="row">
      <IconButton text="back" :onClick="() => router.push(`/shop/${shopId}`)">
        <IconArrowBack font-size="24px" />
      </IconButton>
      <H1Title class="title" :text="`Performances of shop ${shop!.name}`" />
      >
    </div>
    <H2Title text="See how well your shop goes" font-size="64px" />
    <div class="row">
      <div class="customers-card card">
        <div class="space-between">
          <IconPersonRaisedHandOutline font-size="48px" color="#AC2531" />
          <div class="column">
            <IconMoving
              v-if="data.totalSales.percentChange > 0"
              font-size="48px"
              color="#46A67B"
            />
            <IconSouthEast v-else font-size="48px" color="#AC2531" />
            <p class="percent">{{ data.totalCustomers.percentChange }} %</p>
          </div>
        </div>
        <p class="sales-number">{{ data.totalCustomers.currentYear }}</p>
        <p class="sales-text">Customers in {{ currentYear }}</p>
      </div>
      <div class="sales-card card">
        <div class="space-between">
            <IconSellOutline font-size="48px" color="#AC2531" />
            <div class="column">
                <IconMoving
                v-if="data.totalSales.percentChange > 0"
                font-size="48px"
                color="#46A67B"
                />
                <IconSouthEast v-else font-size="48px" color="#AC2531" />
                <p class="percent">{{ data.totalSales.percentChange }} %</p>
            </div>
        </div>
        <p class="sales-number">{{ data.totalSales.currentYear }}</p>
        <p class="sales-text">Sales in {{ currentYear }}</p>
      </div>
    </div>
    <div class="wrap">
        <div class="chart">
            <Bar class="bar-chart" :data="busyHours" />
            <p class="label">Busy Hours</p>
        </div>
        <div class="chart">
            <Line class="bar-chart" :data="salesEvolution" />
            <p class="label">Income Evolution</p>
        </div>
        <div class="pie-chart">
            <Pie :data="productPopularity" />
            <p class="label">Top 10 product part</p>
        </div>
    </div>
  </main>
</template>

<style scoped>
.title {
  max-width: 900px;
  margin: 0 auto;
  text-align: center;
  margin-top: 2em;
}

main {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  width: 100%;
  gap: 1rem;
  height: fit-content;
}

.row {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: center;
  gap: 2rem;
}

.space-between {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  gap: 1rem;
  width: 300px;
}

.card{
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 0.8rem;
    padding: 1rem;
    border-radius: 5px;
    box-shadow: 0px 4px 16px 4px rgba(0, 0, 0, 0.15);
    min-width: 400px;
}

.sales-card{
    background-color: #FACDD1;
}

.customers-card{
    background-color: #F7ECED;
}

.sales-number {
  font-size: 48px;
  color: #AC2531;
}

.sales-text {
  font-size: 24px;
  color: #AC2531;
}

.bar-chart{
    min-height: 300px;
    min-width: 550px;
}

.pie-chart{
    min-width: 400px;
}
.wrap{
    display: flex;
    flex-wrap: wrap;
    flex-direction: row;
    align-items: center;
    justify-content: center;
    gap: 2rem;
    width: 80%;
    margin-top: 2rem;
}

.label{
    font-family: 'Montserrat Alternates', sans-serif;
    font-weight: 500;
}
</style>

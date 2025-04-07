import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'
import SignInView from '@/views/SignInView.vue'
import SignUpView from '@/views/SignUpView.vue'
import VendorHomeView from '@/views/VendorHomeView.vue'
import CreateShopView from '@/views/CreateShopView.vue'
import EditShopView from '@/views/EditShopView.vue'
import ShopProductsVIew from '@/views/ShopProductsVIew.vue'
import AddProductView from '@/views/AddProductView.vue'
import ProductView from '@/views/ProductView.vue'
import EditProductView from '@/views/EditProductView.vue'
import ShopKPIView from '@/views/ShopKPIView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomeView,
    },
    {
      path: "/login",
      name: "login",
      component: SignInView
    },
    {
      path: "/sign-up",
      name: "signup",
      component: SignUpView
    },
    {
      path: "/home",
      name: "vendor-home",
      component: VendorHomeView
    },
    {
      path: "/create-shop",
      name: "create-shop",
      component: CreateShopView
    },
    {
      path: "/edit-shop/:id",
      name: "edit-shop",
      component: EditShopView
    },
    {
      path: "/shop/:id",
      name: "shop",
      component: ShopProductsVIew
    },
    {
      path: "/shop/:id/add-product",
      name: "add-product",
      component: AddProductView
    },
    {
      path: "/shop/:shopId/products/:productId",
      name: "product",
      component: ProductView
    },
    {
      path: '/shop/:shopId/edit-product/:productId',
      name: 'edit-product',
      component: EditProductView
    },
    {
      path: '/shop/:shopId/kpi',
      name: 'kpi',
      component: ShopKPIView
    }
  ],
})

export default router

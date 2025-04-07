import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'
import SignInView from '@/views/SignInView.vue'
import SignUpView from '@/views/SignUpView.vue'
import VendorHomeView from '@/views/VendorHomeView.vue'
import CreateShopView from '@/views/CreateShopView.vue'
import EditShopView from '@/views/EditShopView.vue'

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
    }
  ],
})

export default router

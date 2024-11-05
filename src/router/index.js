import { createRouter, createWebHistory } from 'vue-router'
import StoresView from '../views/StoresView.vue'

const routes = [
  {
    path: '/',
    redirect: '/stores'
  },
  {
    path: '/stores',
    name: 'stores',
    component: StoresView
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router 
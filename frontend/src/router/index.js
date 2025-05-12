import { createRouter, createWebHistory } from 'vue-router'
import Login from '@/pages/Login.vue'
import Signup from '@/pages/Signup.vue'
import Workspace from '@/pages/Workspace.vue'
import Report from '@/pages/Report.vue'

const routes = [
  { path: '/login', component: Login },
  { path: '/signup', component: Signup },
  { path: '/workspace', component: Workspace },
  { path: '/report', component: Report },
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
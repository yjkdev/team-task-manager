<script setup>
import { useUserStore } from '@/store/user'
import { useRouter } from 'vue-router'

const userStore = useUserStore()
const router = useRouter()

const handleLogout = () => {
  userStore.clearUserData()
  router.push('/login')
}
</script>

<template>
  <div>
    <h2>워크스페이스</h2>
    <p>환영합니다, {{ userStore.user?.name || '사용자' }}님!</p>
    <p>이메일: {{ userStore.user?.email || 'test@test.com' }}</p>
    <button @click="handleLogout">로그아웃</button>
  </div>
</template>

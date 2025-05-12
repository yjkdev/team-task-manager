<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import api from '@/api/axios'
import { useUserStore } from '@/store/user'

const email = ref('')
const password = ref('')
const error = ref(null)
const router = useRouter()
const userStore = useUserStore()

const handleLogin = async () => {
  error.value = null
  try {
    const response = await api.post('/login', {
      email: email.value,
      password: password.value
    })

    const { token, user } = response.data
    userStore.setUserData({ token, user })
    console.log('로그인 성공:', response.data)

    router.push('/workspace') // 실제 존재하는 페이지로 수정
  } catch (err) {
    console.error('로그인 실패:', err)
    error.value = err.response?.data?.error || '로그인 중 오류가 발생했습니다.'
  }
}
</script>

<template>
  <div>
    <h2>로그인</h2>
    <form @submit.prevent="handleLogin">
      <div><label>이메일</label><input v-model="email" type="email" required /></div>
      <div><label>비밀번호</label><input v-model="password" type="password" required /></div>
      <button type="submit">로그인</button>
    </form>
    <p v-if="error" style="color: red;">{{ error }}</p>
    <p>
      계정이 없으신가요?
      <router-link to="/signup">회원가입</router-link>
    </p>
  </div>
</template>
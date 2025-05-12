<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import api from '@/api/axios'

const name = ref('')
const email = ref('')
const password = ref('')
const passwordConfirmation = ref('')
const error = ref(null)
const router = useRouter()

const handleSignup = async () => {
  error.value = null
  if (password.value !== passwordConfirmation.value) {
    error.value = '비밀번호가 일치하지 않습니다.'
    return
  }

  try {
    const response = await api.post('/signup', {
      user: {
        name: name.value,
        email: email.value,
        password: password.value,
        password_confirmation: passwordConfirmation.value
      }
    })
    console.log('회원가입 성공:', response.data)
    router.push('/login')
  } catch (err) {
    console.error('회원가입 실패:', err)
    error.value = err.response?.data?.error || '회원가입 중 오류가 발생했습니다.'
  }
}
</script>

<template>
  <div>
    <h2>회원가입</h2>
    <form @submit.prevent="handleSignup">
      <div><label>이름</label><input v-model="name" type="text" required /></div>
      <div><label>이메일</label><input v-model="email" type="email" required /></div>
      <div><label>비밀번호</label><input v-model="password" type="password" required /></div>
      <div><label>비밀번호 확인</label><input v-model="passwordConfirmation" type="password" required /></div>
      <button type="submit">회원가입</button>
    </form>
    <p v-if="error" style="color: red;">{{ error }}</p>
  </div>
</template>
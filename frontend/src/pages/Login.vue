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
    console.log('ログイン成功:', response.data)

    router.push('/workspace')
  } catch (err) {
    console.error('ログイン失敗:', err)
    error.value = err.response?.data?.error || 'ログイン中にエラーが発生しました。'
  }
}
</script>

<template lang="pug">
div
  h2 ログイン
  form(@submit.prevent="handleLogin")
    div
      label メールアドレス
      input(v-model="email" type="email" required)
    div
      label パスワード
      input(v-model="password" type="password" required)
    button(type="submit") ログイン
  p(v-if="error" style="color: red") {{ error }}
  p
    | アカウントをお持ちでない方はこちら：
    router-link(to="/signup") 会員登録
</template>
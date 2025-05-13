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
    error.value = 'パスワードが一致しません。'
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
    console.log('会員登録成功:', response.data)
    router.push('/login')
  } catch (err) {
    console.error('会員登録失敗:', err)
    error.value = err.response?.data?.error || '会員登録中にエラーが発生しました。'
  }
}
</script>

<template lang="pug">
div
  h2 会員登録
  form(@submit.prevent="handleSignup")
    div
      label 名前
      input(v-model="name" type="text" required)
    div
      label メールアドレス
      input(v-model="email" type="email" required)
    div
      label パスワード
      input(v-model="password" type="password" required)
    div
      label パスワード確認
      input(v-model="passwordConfirmation" type="password" required)
    button(type="submit") 会員登録
  p(v-if="error" style="color: red") {{ error }}
</template>
import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useUserStore = defineStore('user', () => {
  const token = ref(null)
  const user = ref(null)

  function setUserData(payload) {
    token.value = payload.token
    user.value = payload.user
  }

  function clearUserData() {
    token.value = null
    user.value = null
  }

  return { token, user, setUserData, clearUserData }
})
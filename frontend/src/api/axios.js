import axios from 'axios'
import { useUserStore } from '@/store/user'

const api = axios.create({
  baseURL: 'http://localhost:3000',
  withCredentials: true,
  headers: {
    'Content-Type': 'application/json',
  },
})

// 요청마다 토큰 추가 (단, 로그인/회원가입은 제외)
api.interceptors.request.use((config) => {
  const userStore = useUserStore()

  // 예외 URL 설정
  const publicEndpoints = ['/login', '/signup']
  const isPublic = publicEndpoints.some((url) => config.url?.includes(url))

  if (!isPublic && userStore.token) {
    config.headers.Authorization = `Bearer ${userStore.token}`
  }
  return config
})

export default api
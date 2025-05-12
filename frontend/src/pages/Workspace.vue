<script setup>
import { ref, onMounted } from 'vue'
import api from '@/api/axios'
import { useUserStore } from '@/store/user'
import { useRouter } from 'vue-router'

const userStore = useUserStore()
const router = useRouter()

const workspaces = ref([])
const workspaceName = ref('')
const error = ref(null)

const fetchWorkspaces = async () => {
  try {
    const response = await api.get('/workspaces')
    workspaces.value = response.data
  } catch (err) {
    console.error('워크스페이스 목록 조회 실패:', err)
    error.value = '워크스페이스를 불러오는 중 오류가 발생했습니다.'
  }
}

const createWorkspace = async () => {
  if (!workspaceName.value.trim()) return
  try {
    const response = await api.post('/workspaces', {
      workspace: { name: workspaceName.value }
    })
    workspaces.value.push(response.data.workspace)
    workspaceName.value = ''
  } catch (err) {
    console.error('워크스페이스 생성 실패:', err)
    error.value = err.response?.data?.error || '생성 중 오류가 발생했습니다.'
  }
}

const handleLogout = () => {
  userStore.clearUserData()
  router.push('/login')
}

onMounted(() => {
  fetchWorkspaces()
})
</script>

<template>
  <div>
    <h2>워크스페이스</h2>
    <p>환영합니다, {{ userStore.user?.name || '사용자' }}님!</p>
    <p>이메일: {{ userStore.user?.email || 'test@test.com' }}</p>
    <button @click="handleLogout">로그아웃</button>

    <form @submit.prevent="createWorkspace">
      <input v-model="workspaceName" placeholder="워크스페이스 이름 입력" />
      <button type="submit">생성</button>
    </form>
    <p v-if="error" style="color: red;">{{ error }}</p>
    <ul>
      <li v-for="ws in workspaces" :key="ws.id">{{ ws.name }}</li>
    </ul>
  </div>
</template>
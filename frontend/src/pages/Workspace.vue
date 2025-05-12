<script setup>
import { ref, onMounted, watch } from 'vue'
import api from '@/api/axios'
import { useUserStore } from '@/store/user'
import { useRouter } from 'vue-router'

const userStore = useUserStore()
const router = useRouter()
const workspaces = ref([])
const workspaceName = ref('')
const selectedWorkspaceId = ref(null)
const tasks = ref([])
const taskTitle = ref('')
const taskDescription = ref('')
const editingTaskId = ref(null)
const error = ref(null)
const statusFilter = ref('')
const categoryFilter = ref('')

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

const fetchTasks = async (workspaceId) => {
  try {
    const params = {}
    if (statusFilter.value) params.status = statusFilter.value
    if (categoryFilter.value) params.category = categoryFilter.value

    const response = await api.get(`/workspaces/${workspaceId}/tasks`, { params })
    tasks.value = response.data
  } catch (err) {
    console.error('태스크 목록 조회 실패:', err)
    error.value = '태스크를 불러오는 중 오류가 발생했습니다.'
  }
}

const handleWorkspaceClick = (id) => {
  selectedWorkspaceId.value = id
  fetchTasks(id)
}

const createOrUpdateTask = async () => {
  if (!taskTitle.value.trim()) return
  try {
    if (editingTaskId.value) {
      const response = await api.put(`/workspaces/${selectedWorkspaceId.value}/tasks/${editingTaskId.value}`, {
        task: {
          title: taskTitle.value,
          description: taskDescription.value
        }
      })
      const index = tasks.value.findIndex(t => t.id === editingTaskId.value)
      if (index !== -1) tasks.value[index] = response.data.task
    } else {
      const response = await api.post(`/workspaces/${selectedWorkspaceId.value}/tasks`, {
        task: {
          title: taskTitle.value,
          description: taskDescription.value,
          assigned_user_id: userStore.user?.id
        }
      })
      tasks.value.push(response.data.task)
    }
    taskTitle.value = ''
    taskDescription.value = ''
    editingTaskId.value = null
  } catch (err) {
    console.error('태스크 저장 실패:', err)
    error.value = err.response?.data?.error || '태스크 저장 중 오류가 발생했습니다.'
  }
}

const deleteTask = async (taskId) => {
  try {
    await api.delete(`/workspaces/${selectedWorkspaceId.value}/tasks/${taskId}`)
    tasks.value = tasks.value.filter(task => task.id !== taskId)
  } catch (err) {
    console.error('태스크 삭제 실패:', err)
    error.value = '태스크 삭제 중 오류가 발생했습니다.'
  }
}

const toggleStatus = async (taskId) => {
  try {
    const response = await api.patch(`/workspaces/${selectedWorkspaceId.value}/tasks/${taskId}/toggle_status`)
    const index = tasks.value.findIndex(task => task.id === taskId)
    if (index !== -1) tasks.value[index].status = response.data.status
  } catch (err) {
    console.error('상태 토글 실패:', err)
    error.value = '상태 변경 중 오류가 발생했습니다.'
  }
}

const startEdit = (task) => {
  taskTitle.value = task.title
  taskDescription.value = task.description
  editingTaskId.value = task.id
}

const handleLogout = () => {
  userStore.clearUserData()
  router.push('/login')
}

watch([statusFilter, categoryFilter], () => {
  if (selectedWorkspaceId.value) fetchTasks(selectedWorkspaceId.value)
})

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
      <li
        v-for="ws in workspaces"
        :key="ws.id"
        @click="handleWorkspaceClick(ws.id)"
        style="cursor: pointer;"
      >
        {{ ws.name }}
      </li>
    </ul>

    <div v-if="selectedWorkspaceId">
      <h3>태스크 목록</h3>

      <div>
        상태:
        <select v-model="statusFilter">
          <option value="">전체</option>
          <option value="todo">할 일</option>
          <option value="done">완료</option>
        </select>
        카테고리:
        <input v-model="categoryFilter" placeholder="카테고리" />
      </div>

      <form @submit.prevent="createOrUpdateTask">
        <input v-model="taskTitle" placeholder="업무 제목" />
        <input v-model="taskDescription" placeholder="업무 설명" />
        <button type="submit">업무 {{ editingTaskId ? '수정' : '추가' }}</button>
      </form>

      <ul>
        <li v-for="task in tasks" :key="task.id">
          {{ task.title }} - {{ task.description }} - {{ task.status }}
          <button @click="() => toggleStatus(task.id)">상태 토글</button>
          <button @click="() => startEdit(task)">수정</button>
          <button @click="() => deleteTask(task.id)">삭제</button>
        </li>
      </ul>
    </div>
  </div>
</template>
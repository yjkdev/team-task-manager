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
    console.error('ワークスペース一覧の取得に失敗:', err)
    error.value = 'ワークスペースの取得中にエラーが発生しました。'
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
    console.error('ワークスペース作成に失敗:', err)
    error.value = err.response?.data?.error || '作成中にエラーが発生しました。'
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
    console.error('タスク一覧の取得に失敗:', err)
    error.value = 'タスクの取得中にエラーが発生しました。'
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
    console.error('タスク保存に失敗:', err)
    error.value = err.response?.data?.error || 'タスク保存中にエラーが発生しました。'
  }
}

const deleteTask = async (taskId) => {
  try {
    await api.delete(`/workspaces/${selectedWorkspaceId.value}/tasks/${taskId}`)
    tasks.value = tasks.value.filter(task => task.id !== taskId)
  } catch (err) {
    console.error('タスク削除に失敗:', err)
    error.value = 'タスク削除中にエラーが発生しました。'
  }
}

const toggleStatus = async (taskId) => {
  try {
    const response = await api.patch(`/workspaces/${selectedWorkspaceId.value}/tasks/${taskId}/toggle_status`)
    const index = tasks.value.findIndex(task => task.id === taskId)
    if (index !== -1) tasks.value[index].status = response.data.status
  } catch (err) {
    console.error('ステータス切替に失敗:', err)
    error.value = 'ステータス変更中にエラーが発生しました。'
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

const handleReport = () => {
  router.push('/report')
}

watch([statusFilter, categoryFilter], () => {
  if (selectedWorkspaceId.value) fetchTasks(selectedWorkspaceId.value)
})

onMounted(() => {
  fetchWorkspaces()
})
</script>

<template lang="pug">
div
  h2 ワークスペース
  p ようこそ、{{ userStore.user?.name || 'ユーザー' }}さん！
  p メールアドレス: {{ userStore.user?.email || 'test@test.com' }}
  button(@click="handleReport") 📊 進捗レポートを見る
  button(@click="handleLogout") ログアウト

  form(@submit.prevent="createWorkspace")
    input(v-model="workspaceName" placeholder="ワークスペース名を入力")
    button(type="submit") 作成

  p(v-if="error" style="color: red") {{ error }}

  ul
    li(
      v-for="ws in workspaces"
      :key="ws.id"
      @click="handleWorkspaceClick(ws.id)"
      style="cursor: pointer;"
    ) {{ ws.name }}

  div(v-if="selectedWorkspaceId")
    h3 タスク一覧

    div
      | ステータス:
      select(v-model="statusFilter")
        option(value="") すべて
        option(value="todo") やること
        option(value="done") 完了
      | カテゴリ:
      input(v-model="categoryFilter" placeholder="カテゴリ")

    form(@submit.prevent="createOrUpdateTask")
      input(v-model="taskTitle" placeholder="タスク名")
      input(v-model="taskDescription" placeholder="説明")
      button(type="submit") タスク {{ editingTaskId ? '修正' : '追加' }}

    ul
      li(v-for="task in tasks" :key="task.id")
        | {{ task.title }} - {{ task.description }} - {{ task.status }}
        button(@click="() => toggleStatus(task.id)") ステータス切替
        button(@click="() => startEdit(task)") 修正
        button(@click="() => deleteTask(task.id)") 削除
</template>
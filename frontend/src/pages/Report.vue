<script setup>
import { ref, onMounted } from 'vue'
import api from '@/api/axios'

const reports = ref([])
const error = ref(null)

const fetchReports = async () => {
  try {
    const response = await api.get('/admin/task_progress_reports')
    reports.value = response.data
  } catch (err) {
    console.error('集計データの取得に失敗しました:', err)
    error.value = '集計データの読み込み中にエラーが発生しました。'
  }
}

onMounted(() => {
  fetchReports()
})

</script>

<template lang="pug">
div
  h2 タスク進捗レポート
  router-link(to="/workspace") ← ワークスペースへ戻る
  p(v-if="error" style="color: red") {{ error }}
  ul
    li(v-for="report in reports" :key="report.id")
      | {{ new Date(report.collected_at).toLocaleString() }} - {{ report.user_name }}:
      |  {{ report.done_tasks }}/{{ report.total_tasks }} 完了 ({{ report.progress_rate }}%)
</template>
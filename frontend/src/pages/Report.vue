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
    console.error('집계 데이터 조회 실패:', err)
    error.value = '집계 데이터를 불러오는 중 오류가 발생했습니다.'
  }
}

onMounted(() => {
  fetchReports()
  // setInterval(fetchReports, 180000)  // 3분마다 자동 새로고침
})

</script>

<template>
  <div>
    <h2>업무 진행률 리포트</h2>
    <router-link to="/workspace">← 워크스페이스로 돌아가기</router-link>
    <p v-if="error" style="color: red;">{{ error }}</p>
    <table>
      <li v-for="report in reports" :key="report.id">
        {{ new Date(report.collected_at).toLocaleString() }} - {{ report.user_name }}:
        {{ report.done_tasks }}/{{ report.total_tasks }} 완료 ({{ report.progress_rate }}%)
      </li>
    </table>
  </div>
</template>
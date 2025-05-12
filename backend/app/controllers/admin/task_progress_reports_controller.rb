module Admin
  class TaskProgressReportsController < ApplicationController
    def index
      reports = ::TaskProgressReport
                  .includes(:user)
                  .order(collected_at: :desc)
                  .limit(10)

      render json: reports.map { |report|
        {
          id: report.id,
          user_id: report.user_id,
          user_name: report.user&.name || '이름 없음',
          total_tasks: report.total_tasks,
          done_tasks: report.done_tasks,
          progress_rate: report.progress_rate,
          collected_at: report.collected_at
        }
      }
    end
  end
end
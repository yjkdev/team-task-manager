module Admin
  class TaskProgressReportsController < ApplicationController
    def index
      reports = ::TaskProgressReport.order(collected_at: :desc).limit(10)
      render json: reports
    end
  end
end
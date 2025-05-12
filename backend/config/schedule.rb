set :output, "log/cron.log"
env :RAILS_ENV, 'development'
job_type :rake, "cd :path && bundle exec rake :task --silent :output"

every 3.minutes do
  rake 'task_progress:report'
end

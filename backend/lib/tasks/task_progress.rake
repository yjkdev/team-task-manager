namespace :task_progress do
  desc "タスク進捗率を集計してDBに保存"
  task report: :environment do
    puts "== タスク進捗レポート =="

    User.find_each do |user|
      tasks = user.assigned_tasks
      total = tasks.count
      done = tasks.where(status: 'done').count
      rate = total > 0 ? (done.to_f / total * 100).round(1) : 0.0

      TaskProgressReport.create!(
        user_id: user.id,
        total_tasks: total,
        done_tasks: done,
        progress_rate: rate,
        collected_at: Time.current
      )

      puts "ユーザー：#{user.name} (ID: #{user.id})"
      puts "- 総タスク数: #{total}"
      puts "- 完了タスク数: #{done}"
      puts "- 進捗率: #{rate}%"
      puts "---------------------------"
    end
  end

  desc "3分ごとにタスク進捗レポートを集計（手動ループ版）"
  task report_loop: :environment do
    loop do
      Rake::Task["task_progress:report"].invoke
      Rake::Task["task_progress:report"].reenable
      sleep 180 # 3분 대기
    end
  end
end
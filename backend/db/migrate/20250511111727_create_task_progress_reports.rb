class CreateTaskProgressReports < ActiveRecord::Migration[7.1]
  def change
    create_table :task_progress_reports do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :total_tasks, null: false, default: 0
      t.integer :done_tasks, null: false, default: 0
      t.float :progress_rate, null: false, default: 0.0
      t.datetime :collected_at, null: false

      t.timestamps
    end
  end
end

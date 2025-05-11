class FixAssignedUserReferenceInTasks < ActiveRecord::Migration[7.1]
  def change
    remove_column :tasks, :assigned_user_id, :integer
    add_reference :tasks, :assigned_user, null: false, foreign_key: { to_table: :users }
  end
end

class User < ApplicationRecord
  has_secure_password
  has_many :user_workspaces
  has_many :workspaces, through: :user_workspaces
  has_many :assigned_tasks, class_name: 'Task', foreign_key: :assigned_user_id
end
class Task < ApplicationRecord
  belongs_to :workspace
  belongs_to :assigned_user, class_name: 'User', foreign_key: :assigned_user_id
end

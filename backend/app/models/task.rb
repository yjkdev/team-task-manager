class Task < ApplicationRecord
  belongs_to :workspace
  belongs_to :assigned_user, class_name: 'User'
end

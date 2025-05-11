class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.string :status
      t.string :category
      t.references :workspace, null: false, foreign_key: true
      t.references :assigned_user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

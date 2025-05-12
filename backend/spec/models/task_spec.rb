require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user) { User.create(name: "キム・デベロッパー", email: "dev@example.com", password: "password") }
  let(:workspace) { Workspace.create(name: "開発チーム") }

  it "必須項目がすべて存在する場合、有効である" do
    task = Task.new(
      title: "機能実装",
      description: "ログイン機能の実装",
      status: "pending",
      category: "開発",
      assigned_user_id: user.id,
      workspace_id: workspace.id
    )
    expect(task).to be_valid
  end

  it "titleが存在しない場合、無効である" do
    task = Task.new(
      title: nil,
      workspace_id: workspace.id,
      assigned_user_id: user.id
    )
    expect(task).to_not be_valid
  end

  it "workspace_idが存在しない場合、無効である" do
    task = Task.new(
      title: "タイトル",
      assigned_user_id: user.id
    )
    expect(task).to_not be_valid
  end

  it "assigned_user_idが存在しない場合、無効である" do
    task = Task.new(
      title: "タイトル",
      workspace_id: workspace.id
    )
    expect(task).to_not be_valid
  end
end
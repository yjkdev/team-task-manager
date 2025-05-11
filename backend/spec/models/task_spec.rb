require 'rails_helper'

RSpec.describe Task, type: :model do
  it 'title(제목)이 없으면 유효하지 않다' do
    task = Task.new(title: nil, workspace_id: 1, assigned_user_id: 1)
    expect(task).not_to be_valid
  end

  it 'title(제목)이 있으면 유효하다' do
    task = Task.new(title: '테스트 제목', workspace_id: 1, assigned_user_id: 1)
    expect(task).to be_valid
  end
end
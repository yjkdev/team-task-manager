class TasksController < ApplicationController
  def index
  workspace = @current_user.workspaces.find_by(id: params[:workspace_id])

  if workspace
    tasks = workspace.tasks

    tasks = tasks.where(status: params[:status]) if params[:status].present?
    tasks = tasks.where(assigned_user_id: params[:assigned_user_id]) if params[:assigned_user_id].present?
    tasks = tasks.where(category: params[:category]) if params[:category].present?

    render json: tasks
    else
      render json: { error: '해당 워크스페이스를 찾을 수 없습니다' }, status: :not_found
    end
  end

  # 업무 생성
  def create
    task = Task.new(task_params)
    task.workspace_id = params[:workspace_id]

    if task.save
      render json: { message: '업무가 등록되었습니다', task: task }, status: :created
    else
      render json: { error: task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # 업무 수정
  def update
  task = Task.find_by(id: params[:id], workspace_id: params[:workspace_id])

  if task
    if task.update(task_params)
      render json: { message: '업무가 수정되었습니다', task: task }, status: :ok
    else
      render json: { error: task.errors.full_messages }, status: :unprocessable_entity
    end
    else
      render json: { error: '해당 업무를 찾을 수 없습니다' }, status: :not_found
    end
  end

  # 업무 삭제
  def destroy
  task = Task.find_by(id: params[:id], workspace_id: params[:workspace_id])

  if task
    task.destroy
    render json: { message: '업무가 삭제되었습니다' }, status: :ok
  else
    render json: { error: '해당 업무를 찾을 수 없습니다' }, status: :not_found
    end
  end

  # 업무 완료 or 완료X 수정
  def toggle_status
  task = Task.find_by(id: params[:id], workspace_id: params[:workspace_id])

  if task
    task.status = task.status == "done" ? "todo" : "done"
    if task.save
      render json: { message: "업무 상태가 변경되었습니다", status: task.status }, status: :ok
    else
      render json: { error: task.errors.full_messages }, status: :unprocessable_entity
    end
    else
      render json: { error: "해당 업무를 찾을 수 없습니다" }, status: :not_found
    end
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :status, :category, :assigned_user_id)
  end
end

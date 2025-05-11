class WorkspacesController < ApplicationController
  def create
    workspace = Workspace.new(workspace_params)
    if workspace.save
      UserWorkspace.create(user: @current_user, workspace: workspace)
      render json: { message: '워크스페이스 생성 완료', workspace: workspace }, status: :created
    else
      render json: { error: workspace.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def workspace_params
    params.require(:workspace).permit(:name)
  end
end

class WorkspacesController < ApplicationController
  def index
    workspaces = @current_user.workspaces
    render json: workspaces
  end
end
class Project::Update < Project::Crud
  attr_reader :project

  def initialize(current_user, params, project)
    super(current_user, params)
    @project = project
    @project.attributes = @params
  end
end

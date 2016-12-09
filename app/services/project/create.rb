class Project::Create < Project::Crud
  attr_reader :project

  def initialize(current_user, params)
    super(current_user, params)
    @project = Project.new(params)
  end
end

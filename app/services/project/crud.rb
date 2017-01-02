class Project::Crud
  MAX_ONLINE_DAYS = 60

  def initialize(current_user, params)
    @current_user = current_user
    @params = params.with_indifferent_access
  end

  def valid?
    project.valid?
    unless @current_user.admin?
      validate_online_days
    end

    project.errors.empty?
  end

  def process
    return false unless valid?
    project.save
  end

  private

  def project
    raise NotImplementedError
  end

  def validate_online_days
    project.errors.add(:online_days, :less_than_or_equal_to) if online_days_param > MAX_ONLINE_DAYS
  end

  def online_days_param
    @params[:online_days].to_i
  end
end

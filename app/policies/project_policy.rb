class ProjectPolicy < ApplicationPolicy

  self::UserScope = Struct.new(:current_user, :user, :scope) do
    def resolve
      if current_user.try(:admin?) || current_user == user
        scope.without_state('deleted')
      else
        scope.without_state(['deleted', 'draft', 'in_analysis', 'rejected'])
      end
    end
  end

  def create?
    done_by_owner_or_admin?
  end

  def update?
    create?
  end

  def send_to_analysis?
    create?
  end

  def edit_partner?
    is_admin?
  end

  def permitted_attributes
    if user.present? && (user.admin? || is_project_channel_admin? || (record.draft? || record.rejected? || record.in_analysis?))
      p_attr = [channel_ids: [], project_images_attributes: [:image, :caption, :id, :_destroy], project_partners_attributes: [:image, :link, :id, :_destroy]]
      p_attr << record.attribute_names.map(&:to_sym)
      {project: p_attr.flatten}
    else
      {project: [:about, :video_url, :uploaded_image, :headline]}
    end
  end
end


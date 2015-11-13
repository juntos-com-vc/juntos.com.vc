class SubgoalPolicy < ApplicationPolicy
  def create?
    is_admin?
  end

  def update?
    is_admin?
  end

  def sort?
    is_admin?
  end

  def destroy?
    is_admin?
  end

  def permitted_attributes
    attributes = record.attribute_names.map(&:to_sym)
    { subgoal: attributes }
  end
end


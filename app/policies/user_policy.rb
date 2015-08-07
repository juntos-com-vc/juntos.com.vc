class UserPolicy < ApplicationPolicy
  def destroy?
    done_by_owner_or_admin?
  end

  def credits?
    done_by_owner_or_admin?
  end

  def update?
    done_by_owner_or_admin?
  end

  def update_password?
    done_by_owner_or_admin?
  end

  def unsubscribe_notifications?
    done_by_owner_or_admin?
  end

  def approve?
    user.try(:admin?)
  end

  def permitted_attributes
    u_attrs = [ bank_account_attributes: [:bank_id, :name, :agency, :account, :owner_name, :owner_document, :account_digit, :agency_digit] ]
    u_attrs << record.attribute_names.map(&:to_sym)
    u_attrs += [:remote_doc1_url, :remote_doc2_url, :remote_doc3_url,
                :remote_doc4_url, :remote_doc5_url, :remote_doc6_url,
                :remote_doc7_url, :remote_doc8_url, :remote_doc9_url,
                :remote_doc10_url, :remote_doc11_url, :remote_doc12_url,
                :remote_doc13_url]

    { user: u_attrs.flatten }
  end

  protected
  def done_by_owner_or_admin?
    record == user || user.try(:admin?)
  end
end


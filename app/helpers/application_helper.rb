module ApplicationHelper
  def is_page_responsive?
    controller_name.eql?('projects') && action_name.eql?('show')
  end
end

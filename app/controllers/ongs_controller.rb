class OngsController < ApplicationController
  layout 'juntos_bootstrap'

  def index
    ongs = User.only_organizations.with_visible_projects.order(name: :asc).uniq
    @ongs = ongs.group_by { |ong| ong.name[0].try(:upcase) }
  end

end

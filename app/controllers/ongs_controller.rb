class OngsController < ApplicationController
  layout 'juntos_bootstrap'

  def index
    ongs = User.where(access_type: User.access_types[:legal_entity]).order(name: :asc)
    @ongs = ongs.group_by { |ong| ong.name[0].try(:upcase) }
  end

end

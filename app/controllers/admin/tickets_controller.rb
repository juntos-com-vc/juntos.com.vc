class Admin::TicketsController < Admin::BaseController
  layout 'juntos_bootstrap'

  def shuffle
    puts "------------>>>>>>  <<<<<<-----------"
    project = Project.by_permalink_and_available(params[:permalink]).first!
    puts "#### ------------>>>>>>" + project.name + "<<<<<<-----------"
    sql = "SELECT * FROM tickets WHERE project_id = #{project.id} OFFSET floor(random()*(SELECT count(*) FROM tickets WHERE project_id = #{project.id})) LIMIT 1"
    @ticket = Ticket.find_by_sql(sql)
  end

end

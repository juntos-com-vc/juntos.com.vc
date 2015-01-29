class Admin::TransparencyReportsController < Admin::BaseController
  layout 'juntos_bootstrap'

  def show
    @transparency_report = TransparencyReport.last
    if @transparency_report.nil?
      @transparency_report = TransparencyReport.new
      @transparency_report.save(validate: false)
    end
  end

  def update
    @transparency_report = TransparencyReport.last
    puts 'here'
    @transparency_report.update_attributes(permitted_params[:transparency_report])
    flash[:notice] = t('updated')
    redirect_to admin_transparency_report_path
  end

private
  def permitted_params
    params.permit(transparency_report: [:attachment, :previous_attachment])
  end

end

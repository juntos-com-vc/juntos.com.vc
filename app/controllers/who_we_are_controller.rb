class WhoWeAreController < ApplicationController
  layout 'juntos_bootstrap'

  def show
    @page = Page.find_by(name: Page.names[:who_we_are])
    @staff = User.where(staff: User.staffs[:team]).limit(4)
    @financial_board = User.where(staff: User.staffs[:financial_board]).limit(4)
    @technical_board = User.where(staff: User.staffs[:technical_board]).limit(4)
    @advice_board = User.where(staff: User.staffs[:advice_board]).limit(4)
    @transparency_report = TransparencyReport.last
  end

end

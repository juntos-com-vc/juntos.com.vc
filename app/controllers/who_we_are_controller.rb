class WhoWeAreController < ApplicationController
  layout 'juntos_bootstrap'

  def show
    @page = Page.find_by(name: Page.names[:who_we_are])
    @staff = User.where(staff: User.staffs[:team])
    @financial_board = User.where(staff: User.staffs[:financial_board])
    @technical_board = User.where(staff: User.staffs[:technical_board])
    @advice_board = User.where(staff: User.staffs[:advice_board])
    @transparency_report = TransparencyReport.last
    @mission = Page.find_by(name: Page.names[:mission])
    @vision = Page.find_by(name: Page.names[:vision])
    @values = Page.find_by(name: Page.names[:values])
    @goals = Page.find_by(name: Page.names[:goals])
  end

end

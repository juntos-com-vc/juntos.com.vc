class WhoWeAreController < ApplicationController
  layout 'juntos_bootstrap'

  def show
    @page = Page.find_by(name: Page.names[:who_we_are])

    @team = team_members
    @technical_board = technical_members
    @financial_board = financial_members
    @advice_board = advice_members

    @transparency_report = TransparencyReport.last
    @mission = Page.find_by(name: Page.names[:mission])
    @vision = Page.find_by(name: Page.names[:vision])
    @values = Page.find_by(name: Page.names[:values])
    @goals = Page.find_by(name: Page.names[:goals])
  end

  private

  def staff_members
    @staff_members ||= User.staff
  end

  def team_members
    staff_members.select { |user| user.staffs.include?(User::STAFFS[:team]) }
  end

  def financial_members
    staff_members.select do |user|
      user.staffs.include?(User::STAFFS[:financial_board])
    end
  end

  def technical_members
    staff_members.select do |user|
      user.staffs.include?(User::STAFFS[:technical_board])
    end
  end

  def advice_members
    staff_members.select do |user|
      user.staffs.include?(User::STAFFS[:advice_board])
    end
  end

end

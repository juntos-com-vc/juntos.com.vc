class Projects::RecurringContributionsController < ApplicationController
  def cancel
    contribution = RecurringContribution.where({
      project: params[:id],
      user: current_user
    }).active.first

    contribution.cancel
    redirect_to :back
  end
end

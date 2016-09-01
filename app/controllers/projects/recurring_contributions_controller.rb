class Projects::RecurringContributionsController < ApplicationController
  def cancel
    recurring_contribution = RecurringContribution.where({
      project: params[:id],
      user: current_user
    }).active.order(updated_at: :desc).first

    CancelRecurringContribution.new(recurring_contribution).call

    redirect_to :back
  end
end

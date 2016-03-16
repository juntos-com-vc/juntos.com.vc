class RecurringPaymentWorker
  include Sidekiq::Worker

  def perform
    contributions = RecurringContribution.active.pluck(:id)

    contributions.each do |contribution|
      RecurringPaymentService.perform(contribution)
    end
  end
end

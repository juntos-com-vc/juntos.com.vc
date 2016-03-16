require 'clockwork'
require './config/boot'
require './config/environment'

module Clockwork
  handler do |job|
    puts "Running #{job}"
  end

  every(1.day, 'recurring.payment', if: lambda { |t| t.day == 1 },
        tz: 'America/Sao_Paulo', at: '00:00') do
    RecurringPaymentWorker.perform_async
  end
end

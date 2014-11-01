class Admin::StatisticsController < Admin::BaseController
  layout 'juntos_bootstrap'
  inherit_resources
  defaults  resource_class: Statistics
  actions :index
end

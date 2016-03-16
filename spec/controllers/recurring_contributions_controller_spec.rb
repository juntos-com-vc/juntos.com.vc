require 'rails_helper'

RSpec.describe Projects::RecurringContributionsController, type: :controller do
  let(:contribution) { create :recurring_contribution }
  let(:current_user) { contribution.user }
  
  before do
    allow(controller).to receive(:current_user).and_return(current_user)
  end

  describe "GET cancel" do
    before { get :cancel, id: contribution.project.id }

    it { is_expected.to respond_with :redirect }
  end
end

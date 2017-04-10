require 'rails_helper'

RSpec.describe Project::SubscriptionsPledgedValueQuery do
  describe ".call" do
    let(:project) { create(:project) }

    before { allow_any_instance_of(Project).to receive(:recurring?).and_return(true) }

    subject { described_class.new(project).call }

    context "when the project has subscriptions" do
      before do
        plan_30 = create(:plan, amount: 3000)
        create_list(:subscription, 4, :paid, plan: plan_30, project: project)
      end

      it "returns the subscriptions formatted amount" do
        expect(subject).to eq 120
      end
    end

    context "when the project does not have subscriptions" do
      it "returns zero" do
        is_expected.to be_zero
      end
    end
  end
end

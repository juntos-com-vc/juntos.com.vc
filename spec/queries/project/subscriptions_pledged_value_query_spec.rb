require 'rails_helper'

RSpec.describe Project::SubscriptionsPledgedValueQuery do
  describe ".call" do
    let(:project) { create(:project) }

    before { allow_any_instance_of(Project).to receive(:recurring?).and_return(true) }

    subject { described_class.new(project).call }

    context "when the project has registered subscriptions" do
      context "with paid transactions" do
        let(:standard_plan) { create(:plan, amount: 3000, projects: [project]) }
        let(:premium_plan) { create(:plan, amount: 10000, projects: [project]) }
        let(:subscritpion_for_standard_plan) { create(:subscription, :paid, plan: standard_plan, project: project) }
        let(:subscritpion_for_premium_plan) { create(:subscription, :canceled, plan: premium_plan, project: project) }

        before do
          create(:transaction, status: :paid, subscription: subscritpion_for_standard_plan)
          create(:transaction, status: :paid, subscription: subscritpion_for_premium_plan)
          create(:transaction, status: :refunded, subscription: subscritpion_for_standard_plan)
        end

        it "returns the paid transactions formatted amount" do
          expect(subject).to eq 130
        end
      end

      context "without paid transactions" do
        let(:plan) { create(:plan, projects: [project]) }
        let(:subscription) { create(:subscription, :paid, plan: plan, project: project) }
        let!(:pending_payment_transaction) { create(:transaction, :pending_payment, subscription: subscription) }

        it { is_expected.to be_zero }
      end
    end

    context "when the project does not have plans" do
      let(:project) { create(:project, plans: []) }

      it { is_expected.to be_zero }
    end

    context "when the project does not have subscriptions" do
      it "returns zero" do
        create(:plan, projects: [project])

        is_expected.to be_zero
      end
    end
  end
end

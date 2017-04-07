require 'rails_helper'

RSpec.describe SubscriptionDecorator do
  describe ".project_profile_link" do
    let(:subscription) { create(:subscription).decorate }
    let(:project_url) { h.project_path(subscription.project) }

    subject { subscription.project_profile_link }

    it "returns a link tag to the project profile page" do
      expect(subject).to have_tag(:a, with: { href: project_url, class: 'link'})
    end
  end

  describe ".bank_billet_link" do
    subject { subscription.decorate.bank_billet_link }

    context "when the subscription has bank_billet as the payment method" do
      let(:subscription) { create(:subscription_with_transaction, :bank_billet_payment) }

      it "returns a link tag for the bank billet file" do
        transaction = create(:transaction, bank_billet_url: 'http://bankbillet.com', subscription: subscription)
        allow(subscription).to receive(:current_transaction).and_return transaction

        expect(subject)
          .to have_tag(:a, with: { href: transaction.bank_billet_url, class: 'link' })
      end
    end

    context "when the subscription does not have bank_billet as the payment method" do
      let(:subscription) { create(:subscription_with_transaction, :credit_card_payment) }

      it { is_expected.to be_nil }
    end
  end
end

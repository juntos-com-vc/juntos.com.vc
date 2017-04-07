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
      let(:transaction) { create(:transaction, bank_billet_url: 'http://bankbillet.com', subscription: subscription) }

      before do
        allow(subscription).to receive(:current_transaction).and_return transaction
      end

      context "and the subscription was charged on the same day of its creation" do
        it "returns a link tag for the bank billet file" do
          allow(subscription).to receive(:charge_scheduled_for_today?).and_return true

          expect(subject)
            .to have_tag(:a, with: { href: transaction.bank_billet_url, class: 'link' })
        end
      end

      context "and the subscription was scheduled to be charged on a day different of the day of its creation" do
        let(:peding_bank_billet_message) { I18n.t('projects.subscriptions.show.pending_bank_billet') }
        it "returns a message informing that the bank billet is not generated yet" do
          allow(subscription).to receive(:charge_scheduled_for_today?).and_return false

          expect(subject)
            .to have_tag(:span, text: peding_bank_billet_message)
        end
      end
    end

    context "when the subscription does not have bank_billet as the payment method" do
      let(:subscription) { create(:subscription_with_transaction, :credit_card_payment) }

      it { is_expected.to be_nil }
    end
  end
end

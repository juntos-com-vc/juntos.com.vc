require 'rails_helper'

RSpec.describe ContributionDecorator do
  before do
    I18n.locale = :pt
  end

  describe "#default_payment_method" do
    subject { contribution.decorate.default_payment_method }

    context "when user selects gift card payment" do
      let(:contribution) { create(:contribution, preferred_payment_engine: 'JuntosGiftCard') }

      it { is_expected.to eq('#JuntosGiftCard') }
    end

    context "when user has credits" do
      let(:user)         { create(:user) }
      let(:contribution) { create(:contribution, user: user.reload) }

      before do
        create(:failed_contribution_project, project_value: 100, user: user)
      end

      it { is_expected.to eq('#Credits') }
    end

    context "when it is default payment" do
      let(:contribution) { create(:contribution) }

      it { is_expected.to be_nil }
    end
  end

  describe "#display_confirmed_at" do
    subject{ contribution.display_confirmed_at }
    context "when confirmet_at is not nil" do
      let(:contribution){ build(:contribution, confirmed_at: Time.now) }
      it{ is_expected.to eq(I18n.l(contribution.confirmed_at.to_date)) }
    end

    context "when confirmet_at is nil" do
      let(:contribution){ build(:contribution, confirmed_at: nil) }
      it{ is_expected.to be_nil }
    end
  end

  describe "#display_value" do

    context "when the value has decimal places" do
      subject{ build(:contribution, value: 99.99).display_value }
      it{ is_expected.to eq("R$ 99,99") }
    end

    context "when the value does not have decimal places" do
      subject{ build(:contribution, value: 1).display_value }
      it{ is_expected.to eq("R$ 1,00") }
    end
  end

  describe "#display_slip_url" do
    context "when slip_url is filled" do
      subject { build(:contribution, slip_url: 'http://foo.bar/').display_slip_url }
      it{ is_expected.to eq('http://foo.bar/')}
    end

    context "when slip_url is not filled" do
      subject { build(:contribution).display_slip_url }
      it{ is_expected.to match(/www\.moip\.com\.br/) }
    end
  end
end


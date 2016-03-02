require 'rails_helper'

RSpec.describe RecurringContribution do
  it { is_expected.to belong_to :project }
  it { is_expected.to belong_to :user }
  it { is_expected.to have_many :contributions }
  it { is_expected.to validate_presence_of(:credit_card).on(:update) }

  it do
    is_expected.to validate_numericality_of(:value)
      .is_greater_than_or_equal_to(5.0)
  end

  describe 'scopes' do
    let!(:active_contributions) { create_list :recurring_contribution, 2 }
    let!(:cancelled_contributions) do
      create_list :recurring_contribution, 2, cancelled_at: Time.current
    end

    describe '.active' do
      subject { described_class.active }

      it { is_expected.to match_array active_contributions }
    end

    describe '.cancelled' do
      subject { described_class.cancelled }

      it { is_expected.to match_array cancelled_contributions }
    end
  end

  describe '.on_day' do
    let(:contribution) { create :recurring_contribution }
    let(:other_contribution) do
      create :recurring_contribution, created_at: Time.current.yesterday
    end

    subject { described_class.on_day Time.current.day }

    it { is_expected.to include contribution }
    it { is_expected.not_to include other_contribution }
  end
end

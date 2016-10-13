require 'rails_helper'

RSpec.describe ProjectTotal, type: :model do
  before do
    @project_id = create(:contribution, :pending, value: 10.0, payment_service_fee: 1).project_id
    create(:contribution, :confirmed, value: 10.0, payment_service_fee: 1, project_id: @project_id)
    create(:contribution, :waiting_confirmation, value: 10.0, payment_service_fee: 1, project_id: @project_id)
    create(:contribution, :refunded, value: 10.0, payment_service_fee: 1, project_id: @project_id)
    create(:contribution, :requested_refund, value: 10.0, payment_service_fee: 1, project_id: @project_id)
  end

  describe "#pledged" do
    subject{ ProjectTotal.where(project_id: @project_id).first.pledged }
    it{ is_expected.to eq(20) }
  end

  describe "#total_contributions" do
    subject{ ProjectTotal.where(project_id: @project_id).first.total_contributions }
    it{ is_expected.to eq(2) }
  end

  describe "#total_payment_service_fee" do
    subject { ProjectTotal.where(project_id: @project_id).first.total_payment_service_fee }
    it { is_expected.to eq(2) }
  end
end

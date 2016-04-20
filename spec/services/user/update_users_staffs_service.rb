require 'rails_helper'

RSpec.describe User::UpdateUsersStaffsService do
  describe '.process' do
    let!(:user) { create :user, staff: 2 }

    subject { described_class.process }

    it 'updates the resource' do
      expect { subject }.to change { user.reload.staffs }.from([]).to([2])
    end
  end
end

require 'rails_helper'

RSpec.describe ChannelOwnerPolicy do
  let(:user) { nil }
  let(:channel) { nil }

  subject{ ChannelOwnerPolicy.new(user, Channel::Admin, channel) }

  context "permission access?" do

    context "when user is nil" do
      it "should deny access if user is nil" do
        is_expected.not_to custom_permit(:access?)
      end
    end

    context "whe user is not admin" do
      let(:user) { User.new }
      it "should deny access if user is not admin" do
        is_expected.not_to custom_permit(:access?)
      end
    end

    context "when user is channel admin" do
      let(:user) { create(:user, channel: create(:channel))}
      let(:channel) { user.channel }

      xit "should permit access if user is channel admin" do
        is_expected.to custom_permit(:access?)
      end
    end

    context "when user is admin" do
      let(:user) {
        _user = User.new
        _user.admin = true
        _user
      }
      it "should permit access if user is admin" do
        is_expected.to custom_permit(:access?)
      end
    end
  end
end


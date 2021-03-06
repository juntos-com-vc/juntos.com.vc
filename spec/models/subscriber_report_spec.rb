require 'rails_helper'

RSpec.describe SubscriberReport, type: :model do
  let(:subscriber){ SubscriberReport.first }
  before do
    CatarseSettings[:email_contact] = 'foo@bar.com'
    CatarseSettings[:company_name] = 'Foo Bar Company'
    @channel = create(:channel)
    @user = create(:user, subscriptions: [ @channel ])
  end

  describe "Associations" do
    xit{ is_expected.to belong_to :channel }
  end

  describe ".count" do
    subject{ SubscriberReport.count }
    xit{ is_expected.to eq 1 }
  end

  #describe "#id" do
  #  subject{ subscriber.id }
  #  it{ should eq @user.id }
  #end

  describe "#channel_id" do
    subject{ subscriber.channel_id }
    xit{ is_expected.to eq @channel.id }
  end

  describe "#name" do
    subject{ subscriber.name }
    xit{ is_expected.to eq @user.name }
  end

  describe "#email" do
    subject{ subscriber.email }
    xit{ is_expected.to eq @user.email }
  end
end

require 'rails_helper'

RSpec.describe Admin::ChannelsController, type: :controller do
  let(:admin)        { create(:user, admin: true) }
  let(:current_user) { admin }
  before  { sign_in current_user }

  describe 'POST create' do
    let(:channel) { attributes_for(:channel, recurring: true, custom_submit_text: 'custom_text') }

    it { expect{ put(:create, channel: channel, locale: :pt) }.to change(Channel, :count).by(1) }
  end

  describe 'PUT update' do
    let(:channel)         { create(:channel, recurring: true, custom_submit_text: 'custom_text') }
    let(:updated_channel) { Channel.find(channel.id) }
    let(:category)        { create(:category) }
    let(:channel_attributes) do
      {
        category_id: category.id,
        name: 'new_name',
        email: 'email_channel_123@foo.bar',
        description: 'Foo description bar',
        permalink: 'foo_permalink_test_bar',
        recurring: false,
        custom_submit_text: 'update_custom_text'
      }
    end

    before do
      put(:update, id: channel.id, channel: channel_attributes, locale: :pt)
    end

    it { expect(updated_channel).to have_attributes(channel_attributes) }
  end
end

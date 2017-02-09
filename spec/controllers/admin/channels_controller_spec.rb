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
    let(:updated_channel) { Channel.find channel.id }
    let(:channel_attributes) do
      {
        category_id:        category.id,
        custom_submit_text: 'update_custom_text',
        description:        'Foo description bar',
        email:              'email_channel_123@foo.bar',
        name:               'new_name',
        permalink:          'foo_permalink_test_bar',
        recurring:          false,
        visible:            false
      }
    end

    context "when the channel is recurring" do
      let(:channel) { create(:channel, :recurring) }
      let(:error_message) { I18n.t('admin.channels.messages.recurring.error.update') }

      context "and it has projects associated" do
        before do
          create(:project, channels: [channel])

          put(:update, id: channel.id, channel: channel_attributes, locale: :pt)
        end

        it "does not update the channel" do
          expect(flash[:alert]).to match(error_message)
        end
      end

      context "and it has no projects associated" do
        before do
          put(:update, id: channel.id, channel: channel_attributes, locale: :pt)
        end

        it "updates all the attributes" do
          expect(updated_channel).to have_attributes(channel_attributes)
        end
      end
    end

    context "when the channel is not recurring" do
      let(:channel) { create(:channel, :non_recurring) }

      before do
        put(:update, id: channel.id, channel: channel_attributes, locale: :pt)
      end

      it "updates all the attributes" do
        expect(updated_channel).to have_attributes(channel_attributes)
      end
    end
  end
end

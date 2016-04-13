require 'rails_helper'

RSpec.describe ChannelDecorator do
  let(:channel){ build(:channel, facebook: 'http://www.facebook.com/foobar', twitter: 'http://twitter.com/foobar', website: 'http://foobar.com') }

  describe "#display_facebook" do
    subject{ channel.display_facebook }
    it{ is_expected.to eq('foobar') }
  end

  describe "#display_twitter" do
    subject{ channel.display_twitter }
    it{ is_expected.to eq('@foobar') }
  end

  describe "#display_website" do
    subject{ channel.display_website }
    it{ is_expected.to eq('foobar.com') }
  end

  describe '#submit_your_project_text' do
    subject { channel.submit_your_project_text }

    context 'when channel has a custom submit project text' do
      let(:channel) { build :channel, custom_submit_text: 'Custom text' }

      it { is_expected.to eq channel.custom_submit_text }
    end

    context 'when does not have a custom submit project text' do
      it 'returns the default text' do
        is_expected
          .to eq I18n.t(:submit_your_project, scope: [:layouts, :header])
      end
    end
  end
end


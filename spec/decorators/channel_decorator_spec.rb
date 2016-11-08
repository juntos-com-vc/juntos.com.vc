require 'rails_helper'

RSpec.describe ChannelDecorator do
  let(:channel){ build(:channel, facebook: 'http://www.facebook.com/foobar', twitter: 'http://twitter.com/foobar', website: 'http://foobar.com') }

  describe "#display_facebook" do
    subject{ channel.display_facebook }
    it{ is_expected.to eq('foobar') }
  end

  describe "#statistics_background_color" do
    context "when channel hasn't a color" do
      let(:channel) { build :channel }

      subject { channel.decorator.statistics_background_color }

      it "return the default color" do
        is_expected.to eq('#FEB84C')
      end
    end
    context "when a channel has a color" do
      let(:channel) { build :channel, recurring: false, main_color: '#000' }

      subject { channel.decorator.statistics_background_color }

      it "return the channel color" do
        is_expected.to eq('#000')
      end
    end
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

  describe '#email_image' do
    let(:fake_image) { instance_double('ProfileUploader') }
    let(:fake_email_image) { instance_double('ProfileUploader') }

    subject { channel.email_image }

    before do
      allow(fake_image).to receive(:url)
        .and_return('http://juntos.com.vc/assets/juntos/logo.png')

      allow(fake_email_image).to receive(:url)
        .and_return('http://juntos.com.vc/assets/juntos/logo-small.png')
    end

    context 'when channel has a custom email header image' do
      let(:channel) { build :channel, email_header_image: fake_email_image }

      before do
        allow(channel).to receive_messages(email_header_image: fake_email_image)
      end

      it { is_expected.to eq channel.email_header_image.url }
    end

    context 'when channel does not have a custom email header image' do
      let(:channel) { build :channel, image: fake_image }

      before { allow(channel).to receive_messages(image: fake_image) }

      it { is_expected.to eq channel.image.url }
    end
  end
end

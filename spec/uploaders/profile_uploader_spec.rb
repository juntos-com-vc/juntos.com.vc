require 'rails_helper'

RSpec.describe ProfileUploader do
  include CarrierWave::Test::Matchers

  let(:channel) { create :channel }
  let(:uploader) { ProfileUploader.new(channel, :image) }

  before do
    ProfileUploader.enable_processing = true
    uploader.store!(File.open("#{Rails.root}/spec/fixtures/image.png"))
  end

  after do
    ProfileUploader.enable_processing = false
    uploader.remove!
  end

  describe "#store_dir" do
    subject { uploader.store_dir }

    it { is_expected.to eq("uploads/channel/image/#{channel.id}") }
  end

  describe '#curator_thumb' do
    subject { uploader.curator_thumb }

    it { is_expected.to have_dimensions(1200, 253) }
  end

  describe '#slick' do
    subject { uploader.slick }

    it { is_expected.to have_dimensions(1900, 360) }
  end

  describe '#header' do
    subject { uploader.header }

    it { is_expected.to have_dimensions(176, 38) }
  end

  describe '#email_header' do
    subject { uploader.email_header }

    it { is_expected.to have_dimensions(600, 130) }
  end
end

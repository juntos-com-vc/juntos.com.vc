require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe ChannelImagesProcessWorker do
  describe '.perform_async' do
    let(:image) { 'http://juntos.com.vc/assets/juntos/logo-small.png' }
    let!(:channel) { create :channel }

    subject do
      described_class.perform_async(channel.id, channel.original_image_url,
                                    channel.original_email_header_image_url)
    end

    before do
      channel.update_attributes(original_image_url: image,
        original_email_header_image_url: image)
    end

    it 'enqueues a job' do
      expect { subject }.to change(described_class.jobs, :size).by(1)
    end

    describe 'uploaded image' do
      it 'updates the image resource' do
        Sidekiq::Testing.inline! do
          expect { subject }.to change { channel.reload.image? }
            .from(false).to(true)
        end
      end

      it 'sets the original url to nil' do
        Sidekiq::Testing.inline! do
          expect { subject }
            .to change { channel.reload.original_image_url }
            .from(channel.original_image_url).to(nil)
        end
      end

      it 'sets the image processing field to false' do
        Sidekiq::Testing.inline! do
          expect { subject }.to change { channel.reload.image_processing? }
            .from(true).to(false)
        end
      end
    end

    describe 'uploaded email header image' do
      it 'updates the image resource' do
        Sidekiq::Testing.inline! do
          expect { subject }.to change { channel.reload.email_header_image? }
            .from(false).to(true)
        end
      end

      it 'sets the original url to nil' do
        Sidekiq::Testing.inline! do
          expect { subject }
            .to change { channel.reload.original_email_header_image_url }
            .from(channel.original_email_header_image_url).to(nil)
        end
      end

      it 'sets the image processing field to false' do
        Sidekiq::Testing.inline! do
          expect { subject }
            .to change { channel.reload.email_header_image_processing? }
            .from(true).to(false)
        end
      end
    end
  end
end

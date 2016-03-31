require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe ProjectCoverProcessWorker do
  describe '.perform_async' do
    let(:image) { 'http://juntos.com.vc/assets/juntos/logo-small.png' }
    let!(:project) { create :project }

    subject do
      described_class.perform_async(project.id, project.original_uploaded_image,
                                    project.original_uploaded_cover_image)
    end

    before do
      project.update_attributes(original_uploaded_image: image,
        original_uploaded_cover_image: image)
    end

    it 'enqueues a job' do
      expect { subject }.to change(described_class.jobs, :size).by(1)
    end

    describe 'uploaded image' do
      it 'updates the image resource' do
        Sidekiq::Testing.inline! do
          expect { subject }.to change { project.reload.uploaded_image? }
            .from(false).to(true)
        end
      end

      it 'sets the original url to nil' do
        Sidekiq::Testing.inline! do
          expect { subject }
            .to change { project.reload.original_uploaded_image }
            .from(project.original_uploaded_image).to(nil)
        end
      end

      it 'sets the image processing field to false' do
        Sidekiq::Testing.inline! do
          expect { subject }.to change { project.reload.image_processing? }
            .from(true).to(false)
        end
      end
    end

    describe 'uploaded cover image' do
      it 'updates the image resource' do
        Sidekiq::Testing.inline! do
          expect { subject }.to change { project.reload.uploaded_cover_image? }
            .from(false).to(true)
        end
      end

      it 'sets the original url to nil' do
        Sidekiq::Testing.inline! do
          expect { subject }
            .to change { project.reload.original_uploaded_cover_image }
            .from(project.original_uploaded_cover_image).to(nil)
        end
      end

      it 'sets the image processing field to false' do
        Sidekiq::Testing.inline! do
          expect { subject }
            .to change { project.reload.cover_image_processing? }
            .from(true).to(false)
        end
      end
    end
  end
end

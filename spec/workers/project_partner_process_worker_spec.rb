require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe ProjectPartnerProcessWorker do
  describe '.perform_async' do
    let!(:project_partner) { create :project_partner }

    subject do
      described_class.perform_async(project_partner.id,
                                    project_partner.original_image_url)
    end

    it 'enqueues a job' do
      expect { subject }.to change(described_class.jobs, :size).by(1)
    end

    it 'updates the image resource' do
      Sidekiq::Testing.inline! do
        expect { subject }.to change { project_partner.reload.image? }
          .from(false).to(true)
      end
    end

    it 'sets the original url to nil' do
      Sidekiq::Testing.inline! do
        expect { subject }.to change { project_partner.reload.original_image_url }
          .from(project_partner.original_image_url).to(nil)
      end
    end

    it 'sets the image processing field to false' do
      Sidekiq::Testing.inline! do
        expect { subject }.to change { project_partner.reload.image_processing? }
          .from(true).to(false)
      end
    end
  end
end

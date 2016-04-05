require 'rails_helper'

RSpec.describe User::FixUsersDocumentsURLService do
  xdescribe '.process' do
    let(:fake_document) { 'http://juntos.com.vc/assets/juntos/logo-small.png' }
    let!(:user) { create :user }

    subject { described_class.process }

    before do
      allow_any_instance_of(DocumentUploader)
        .to receive(:url).and_return(fake_document)
    end

    it "updates the resource" do
      expect { subject }.to change { user.reload.original_doc1_url }
          .from(nil).to(fake_document)
    end
  end
end

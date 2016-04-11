require 'rails_helper'

RSpec.describe UserDocumentsUploaderHelper, type: :helper do
  describe '#user_documents_uploader' do
    let(:user) { create :user }
    subject { helper.user_documents_uploader(user) }

    context 'when user is a legal entity' do
      let(:user) { create :user, access_type: 'legal_entity' }

      it 'has a div container for each document type' do
        expect(subject)
          .to have_tag('div', with: { :"data-document-uploader" => true },
                       count: 13)
      end
    end

    context 'when user is an individual' do
      let(:user) { create :user, access_type: 'individual' }

      it 'has a div container for each document type' do
        expect(subject)
          .to have_tag('div', with: { :"data-document-uploader" => true },
                       count: 2)
      end
    end

    it 'has a hidden field to store document url' do
      expect(subject)
        .to have_tag('input', with: {
          type: 'hidden',
          :"data-document-field" => true
        })
    end

    it 'has the s3_direct_upload form to directly upload documents to S3' do
      expect(subject).to have_tag('div', with: { :"data-s3-uploader" => true })
    end

    context 'when user has already uploaded a document' do
      let(:fake_document) { 'http://juntos.com.vc/assets/juntos/logo-small.png' }

      before do
        allow(user).to receive(:original_doc12_url).and_return(fake_document)
      end

      it 'has a link do download the file' do
        expect(subject).to have_tag('a', with: {
          target: '_blank',
          href: fake_document
        })
      end
    end
  end
end

require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe HandleProjectRecipientWorker do
  describe '#perform' do
    let(:project){ create(:project, state: 'draft') }
    let(:id) { 're_ciknzf3jp003eyn6erpmwarkk' } 
    
    bank_account  = {
      'bank_code' => '001',
      'agencia' => '0001',
      'conta' => '000001',
      'conta_dv' => '00',
      'document_number' => '111.111.111-11',
      'legal_name' => 'Juntos com você API'
    }

    context 'when calls the job' do
      it 'enqueues a job' do
        expect { HandleProjectRecipientWorker.perform_async(project.id, bank_account) }
          .to change(HandleProjectRecipientWorker.jobs, :size).by(1)
      end
    end

    context 'when project does not have a recipient' do
      it 'create a recipient in pagarme and update project with recipient id' do
        recipient_instance = double(id: id)
        create_remote_recipient_instance = double(call: recipient_instance)

        allow(CreateRemoteRecipient).to receive(:new)
          .with(bank_account)
          .and_return(create_remote_recipient_instance)

        Sidekiq::Testing.inline! do
          HandleProjectRecipientWorker.perform_async(project.id, bank_account)
        end

        expect(create_remote_recipient_instance).to have_received(:call).once
        expect(project.reload.recipient).to eq(recipient_instance.id)
      end
    end

    context 'when project already have a recipient' do
      it 'update recipient account info in pagarme' do  
        project.update_attributes(recipient: id)
        recipient_instance = double(id: id)
        update_remote_recipient_instance = double(call: recipient_instance)
        
        allow(UpdateRemoteRecipient).to receive(:new)
          .with(bank_account)
          .and_return(update_remote_recipient_instance)

        Sidekiq::Testing.inline! do
          HandleProjectRecipientWorker.perform_async(project.id, bank_account)
        end

        expect(update_remote_recipient_instance).to have_received(:call).once
      end
    end
  end
end

require 'rails_helper'

RSpec.describe UpdateContributionState do
  describe '#call' do
    before do
      create(:user, email: 'financial@administrator.com')
    end

    context 'when transaction status is waiting payment' do
      it 'contribution state changes to waiting confirmation' do
        contribution = create(:contribution, state: 'pending')

        expect { UpdateContributionState.new(contribution).call('waiting_payment') }
          .to change { contribution.reload.state }
          .from('pending').to('waiting_confirmation')
      end
    end

    context 'when transaction status is paid' do
      it 'contribution state changes to confirmed' do
        contribution = create(:contribution, state: 'pending')

        expect { UpdateContributionState.new(contribution).call('paid') }
          .to change { contribution.reload.state }
          .from('pending').to('confirmed')
      end
    end

    context 'when transaction status is authorized' do
      it 'contribution state changes to confirmed' do
        contribution = create(:contribution, state: 'pending')

        expect { UpdateContributionState.new(contribution).call('authorized') }
          .to change { contribution.reload.state }
          .from('pending').to('confirmed')
      end
    end

    context 'when transaction status is pending refund' do
      it 'contribution state changes to requested refund' do
        contribution = create(:contribution, state: 'confirmed')
        
        allow(contribution.user).to receive(:credits)
          .and_return(contribution.value.to_f)

        contribution.project.update_attributes({ state: 'failed' })
        
        UpdateContributionState.new(contribution).call('pending_refund')

        expect(contribution.reload.state).to eq('requested_refund')
      end
    end

   context 'when transaction status is refunded' do
      it 'contribution state changes to refunded' do
        contribution = create(:contribution, state: 'confirmed')

        expect { UpdateContributionState.new(contribution).call('refunded') }
          .to change { contribution.reload.state }
          .from('confirmed').to('refunded')
      end
    end

    context 'when transaction status is refused' do
      it 'contribution state changes to invalid payment' do
        contribution = create(:contribution, state: 'pending')

        expect { UpdateContributionState.new(contribution).call('refused') }
          .to change { contribution.reload.state }
          .from('pending').to('invalid_payment')
      end
    end
  end
end

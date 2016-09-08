#encoding:utf-8
require 'rails_helper'

RSpec.describe PagarmeTransactionsController, type: :controller do
  describe 'POST update status' do
    context 'when is an invalid request' do
      it 'returns a bad request' do
        post :update_status

        parsed_response = JSON.parse(response.body)

        expect(response).to have_http_status :bad_request
        expect(parsed_response).to eq('error' => 'invalid postback')
      end
    end

    context 'when is a valid request' do
      header = { 'HTTP_X_HUB_SIGNATURE' => 'signature' }
      params = { id: 194330, current_status: 'refused' }
      
      before do
        create(:user, email: 'financial@administrator.com')

        allow(PagarMe::Postback).to receive(:valid_request_signature?)
          .and_return(true)
      end
      
      it 'returns success and changes contribution state' do
        contribution = create(:contribution, state: 'pending', payment_id: 194330)
        
        post :update_status, params, header

        expect(response).to have_http_status :success
        expect(contribution.reload.state).to eq('invalid_payment')
      end
    end
  end
end

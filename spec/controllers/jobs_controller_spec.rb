#encoding:utf-8
require 'rails_helper'

RSpec.describe JobsController, type: :controller do
  let(:id) { 'afa6f8193642892fe0add387' }
  describe 'GET status' do
    context 'when get status with job id' do
      it 'should return a json with status' do
        allow(Sidekiq::Status).to receive(:status).with(id).once.and_return('working')

        get :status, id: id, locale: :pt
        
        parsed_response = JSON.parse(response.body)

        expect(response).to have_http_status :success
        expect(parsed_response).to eq('status' => 'working')
      end
    end
  end
end
 

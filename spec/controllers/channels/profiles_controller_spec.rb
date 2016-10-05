require 'rails_helper'

RSpec.describe Channels::ProfilesController, type: :controller do
  let(:channel){ FactoryGirl.create(:channel) }
  let (:project) { FactoryGirl.create(:project) }


  describe "GET show" do
    before do
      channel.projects << project
      allow(request).to receive(:subdomain).and_return(channel.permalink)
      get :show, id: 'sample'
    end

    it 'should return status 200' do
      expect(response).to have_http_status(:success)
    end

    context 'Show statistics' do
      it 'Counts how many projects has inside a channel' do
        expect(assigns(:total_projects)).to eq(1)
      end

      it 'Count how many contributions a channel has' do
        expect(assigns(:total_contributions)).to eq(0)
      end

      it 'Sum pledged from all projects inside a channel' do

      end

    end
  end

end

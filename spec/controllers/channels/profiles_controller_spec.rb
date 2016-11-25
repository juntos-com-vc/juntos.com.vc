require 'rails_helper'

RSpec.describe Channels::ProfilesController, type: :controller do
  let (:channel) { create(:channel) }
  let (:project) { create(:project) }
  let! (:contribution) { create(:contribution, value: 10, project: project) }
  let! (:contribution2) { create(:contribution, value: 10, project: project) }

  describe "GET show" do
    before do
      project.update_attribute(:state, 'successful')
      channel.projects << project
      allow(request).to receive(:subdomain).and_return(channel.permalink)
      get :show, id: 'sample', locale: 'pt'
    end

    it 'should return status 200' do
      expect(response).to be_success
    end

    context 'Show statistics' do
      it 'Counts how many projects has inside a channel' do
        expect(assigns(:total_projects)).to eq(1)
      end

      it 'Count how many contributions a channel has' do
        expect(assigns(:total_contributions)).to eq(2)
      end

      it 'Sum pledged from all projects inside a channel' do
        expect(assigns(:total_pledged)).to eq(20)
      end

    end
  end

end

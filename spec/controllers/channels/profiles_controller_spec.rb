require 'rails_helper'

RSpec.describe Channels::ProfilesController, type: :controller do
  describe "GET show" do
    let (:channel) { create(:channel) }

    it 'should return status 200' do
      allow(request).to receive(:subdomain).and_return(channel.permalink)
      get :show, id: 'sample', locale: 'pt'
      expect(response).to be_success
    end
  end
end

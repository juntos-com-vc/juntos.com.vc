#encoding:utf-8
require 'rails_helper'

RSpec.describe CountriesController, type: :controller do
  let(:country_code) { 'BR' }
  describe 'GET states' do
    context 'when get states with country code' do
      it 'should return a json with a list of states and abreviation' do
        parsed_states = [["AC", "Acre"], 
                         ["AL", "Alagoas"], 
                         ["AM", "Amazonas"]]

        country = double(subdivisions: {"AC" => {"name" => "Acre"}, 
                                        "AL" => {"name" => "Alagoas"}, 
                                        "AM" => {"name" => "Amazonas"}})

        allow(ISO3166::Country).to receive(:[]).with(country_code).and_return(country)

        get :states, country_code: country_code, locale: :pt
        
        parsed_response = JSON.parse(response.body)

        expect(response).to have_http_status :success
        expect(parsed_response).to eq(parsed_states)
      end
    end
  end
end
 

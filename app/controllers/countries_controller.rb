# coding: utf-8
class CountriesController < ApplicationController
  def states
    states = ISO3166::Country[params[:country_code]].subdivisions
    render json: states_parser(states)
  end

  protected
  def states_parser(states)
    states.map { |key, value| [key, value['name']] } 
  end
end

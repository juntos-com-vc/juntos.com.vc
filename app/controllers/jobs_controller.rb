# coding: utf-8
class JobsController < ApplicationController
  def status
    status = Sidekiq::Status::status(params[:id])
    render json: { status: status }
  end
end

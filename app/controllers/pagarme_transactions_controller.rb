class PagarmeTransactionsController < ApplicationController
  skip_before_action :authenticate_user!

  def update_status
    if valid_postback?
      contribution = Contribution.find_by(payment_id: params[:id])

      UpdateContributionState.new(contribution).call(params[:current_status])

      render nothing: true, status: :ok
    else
      render json: { error: 'invalid postback' }, status: :bad_request
    end
  end

  private
  def valid_postback?
    raw_post = request.raw_post
    signature = request.headers['HTTP_X_HUB_SIGNATURE'] || ""
    PagarMe::Postback.valid_request_signature?(raw_post, signature)
  end
end

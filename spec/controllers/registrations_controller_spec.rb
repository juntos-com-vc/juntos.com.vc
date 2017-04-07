require 'rails_helper'

RSpec.describe RegistrationsController, :type => :controller do
  describe "POST create" do
    before do
      request.env["devise.mapping"] = Devise.mappings[:user]
      session[:return_to] = return_to
    end

    context "when there is a redirect path set" do
      let(:return_to) { '/how-it-works' }

      it "redirects to the redirect path set page" do
        post :create, user: attributes_for(:user)

        is_expected.to redirect_to '/how-it-works'
      end
    end

    context "when there is no return back set" do
      let(:return_to) { nil }

      it "redirects to the sign-up success page" do
        post :create, user: attributes_for(:user)

        is_expected.to redirect_to sign_up_success_path
      end
    end
  end
end

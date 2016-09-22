require 'rails_helper'
require 'csv'

RSpec.describe Admin::UsersController, type: :controller do
  subject{ response }
  let(:admin) { create(:user, admin: true) }
  let(:current_user){ admin }

  before do
    allow(controller).to receive(:current_user).and_return(current_user)
  end

  describe "GET index" do
    context "when I'm not logged in" do
      let(:current_user){ nil }
      before do
        get :index, locale: :pt
      end
      it{ is_expected.to redirect_to new_user_registration_path }
    end

    context "when I'm logged as admin" do
      before do
        get :index, locale: :pt
      end
      its(:status){ should == 200 }
    end

    context "pagination" do
      before do
        create_list(:user, 50 - User.count)
      end

      context "responding to html format" do
        before do
          get :index, locale: :en
        end

        it "returns htm as content type" do
          expect(response.content_type).to eq("text/html")
        end

        it "returns 25 users per page" do
          expect(assigns(:users).size).to match(25)
        end
      end

      context "responding to csv format" do
        before do
          get :index, format: :csv, locale: :en
        end

        it "returns csv as content type" do
          expect(response.content_type).to eq("text/csv")
        end

        it "returns all users plus header" do
          csv = CSV.parse(response.body)

          expect(csv.size).to match(51)
        end
      end
    end
  end
end

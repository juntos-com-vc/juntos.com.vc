require 'rails_helper'

RSpec.describe Reports::ContributionReportsForProjectOwnersController, type: :controller do
  include Devise::TestHelpers

  describe '#index' do
    let(:project) { create :project }

    subject { response }

    context 'when the current user has admin access to the project' do
      before { sign_in project.user }

      it 'allows the user to download the report' do
        get :index, project_id: project.id, locale: :pt, format: :csv

        expect(subject).to be_success
      end
    end

    context 'unauthorized access' do
      before { get :index, project_id: project.id, locale: :pt, format: :csv }

      context 'when the current user does not have admin access to the project' do
        let(:unauthorized) { build :user }

        before { sign_in unauthorized }

        it { is_expected.to redirect_to root_path }
      end

      context 'when there is no user logged in' do
        it { is_expected.to redirect_to root_path }
      end
    end
  end
end

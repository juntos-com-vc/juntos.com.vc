require 'rails_helper'

RSpec.describe SubgoalsController, :type => :controller do
  let(:project) { create(:project) }
  let(:user)    { create(:user, admin: true) }

  before  { sign_in user }

  subject { response }

  describe 'POST subgoal create' do
    let(:subgoal_params) do
      { color: 'some color', value: 20.0, description: 'some description' }
    end
    let(:created_project) { Project.find(project.id) }
    let(:created_subgoal) { created_project.subgoals.last }
    let(:redirect_page)   { project_by_slug_path(permalink: project.permalink) + '#dashboard_subgoals' }

    before { post :create, project_id: project.id, subgoal: subgoal_params, locale: :pt }

    context 'when the current user is admin' do
      it { expect(created_subgoal).to have_attributes(subgoal_params) }

      it { is_expected.to redirect_to(redirect_page) }
    end

    context 'when the current user is not admin' do
      let(:user) { create(:user, admin: false) }

      it { expect(created_project.subgoals).to be_empty }
    end
  end
end

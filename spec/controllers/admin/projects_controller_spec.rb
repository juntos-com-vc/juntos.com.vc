require 'rails_helper'

RSpec.describe Admin::ProjectsController, type: :controller do
  subject { response }
  let(:admin) { create(:user, admin: true) }
  let(:current_user) { admin }

  before do
    allow(controller).to receive(:current_user).and_return(current_user)
    request.env['HTTP_REFERER'] = admin_projects_path
  end

  describe 'PUT approve' do
    let(:project) { create(:project, :in_analysis) }
    before        { put :approve, id: project, locale: :pt }

    it { expect(project.reload).to be_online }
  end

  describe "PUT update" do
    let(:project) { create(:project, recommended: false, name: 'old name') }

    before { put :update, id: project, locale: :pt, project: project_new_attributes }

    context "when all the attributes sent are valid" do
      let(:project_new_attributes) do
        {
          name: 'new_name',
          recommended: true
        }
      end

      let(:success_message) { I18n.t('activerecord.project.update.success') }

      it "returns an error flash message indicating the invalid attribute" do
        expect(flash[:notice]).to match success_message
      end

      it { expect(project.reload).to have_attributes(project_new_attributes) }
    end

    context "when an invalid attribute value is sent" do
      let(:project_new_attributes) do
        {
          name: '',
          recommended: true
        }
      end

      let(:error_message) do
        I18n.t('activerecord.attributes.project.name') + " " +
        I18n.t('activerecord.errors.models.project.attributes.name.blank')
      end

      it "returns an error flash message indicating the invalid attribute" do
        expect(flash[:alert]).to match error_message
      end
    end
  end

  describe 'PUT reject' do
    let(:project)       { create(:project, :in_analysis) }
    let(:reject_reason) { 'reject reason' }

    before do
      put :reject, id: project, locale: :pt, project: { reject_reason: reject_reason }
      project.reload
    end

    context 'when the project is in analysis' do
      it { expect(project).to be_rejected }

      it { expect(project.reject_reason).to eq(reject_reason) }

      it { expect(flash[:notice]).to eq('O projeto foi rejeitado') }
    end

    context 'when the project is already rejected' do
      let(:project) { create(:project, :rejected) }

      it { expect(project.reject_reason).not_to eq(reject_reason) }

      it { expect(flash[:notice]).to eq('O projeto já está rejeitado') }
    end
  end

  describe 'PUT push_to_draft' do
    let(:project) { create(:project, :online) }

    before do
      allow(controller).to receive(:current_user).and_return(admin)
      put :push_to_draft, id: project, locale: :pt
    end

    it { expect(project.reload).to be_draft }
  end

  describe 'PUT push_to_trash' do
    let(:project) { create(:project, :draft) }

    before do
      allow(controller).to receive(:current_user).and_return(admin)
      put :push_to_trash, id: project, locale: :pt
    end

    it { expect(project.reload).to be_deleted }
  end

  describe 'GET index' do
    context 'when a user is not logged in' do
      let(:current_user) { nil }
      before             { get :index, locale: :pt }

      it { is_expected.to redirect_to new_user_registration_path }
    end

    context 'when a user is logged as admin' do
      let(:url_namespace_channel) { create(:channel) }
      let(:non_deleted_projects)  { ['project_out_of_a_channel', 'project_in_a_channel'] }
      before do
        create(:project, name: 'project_out_of_a_channel')
        create(:project, channels: [url_namespace_channel], name: 'project_in_a_channel')
        create(:project, :deleted, channels: [url_namespace_channel], name: 'deleted_project')
      end

      context 'is inside a channel' do
        before do
          allow(controller).to receive(:channel) { url_namespace_channel }
          get :index, locale: :pt
        end

        it "should return only projects registered on the admin's current channel" do
          expect(assigns(:projects).map(&:name)).to match_array('project_in_a_channel')
        end

        it { is_expected.to have_http_status(200) }
      end

      context 'is not inside a channel' do
        before do
          allow(controller).to receive(:channel) { nil }
          get :index, locale: :pt
        end

        it 'should return all non-deleted projects' do
          expect(assigns(:projects).map(&:name)).to match_array(non_deleted_projects)
        end

        it { is_expected.to have_http_status(200) }
      end
    end
  end

  describe '.collection' do
    before do
      create(:project, name: 'Project for search')
      create(:project, name: 'Project_name_test')
    end

    context 'when there is a match' do
      before { get :index, locale: :pt, pg_search: 'Project for search' }

      it { expect(assigns(:projects).map(&:name)).to eq(['Project for search']) }
    end

    context 'when there is no match' do
      before { get :index, locale: :pt, pg_search: 'Non-existing Project' }

      it { expect(assigns(:projects)).to be_empty }
    end
  end

  describe 'DELETE destroy' do
    let(:project) { create(:project, :draft) }
    before        { delete :destroy, id: project, locale: :pt }

    context "when I'm not logged in" do
      let(:current_user) { nil }

      it { is_expected.to redirect_to new_user_registration_path }

      it 'should remain in the draft state' do
        expect(project.reload).to be_draft
      end
    end

    context "when I'm logged as admin" do
      it { is_expected.to redirect_to admin_projects_path }

      it 'should change state to deleted' do
        expect(project.reload).to be_deleted
      end
    end
  end

  describe 'POST move_project_to_channel' do
    let(:project) { create(:project, name: 'project_moved_to_channel') }
    let(:channel) { create(:channel) }
    subject       { channel.reload.projects.map(&:name) }

    context 'when there is no project in the channel' do
      it { is_expected.to be_empty }
    end

    context 'when moving a project to the channel' do
      before { post :move_project_to_channel, { :project_id => project.id, :channel_id => channel.id } }

      it { is_expected.to match_array('project_moved_to_channel') }
    end
  end

end

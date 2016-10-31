require 'rails_helper'

RSpec.describe Admin::ProjectsController, type: :controller do
  subject{ response }
  let(:admin) { create(:user, admin: true) }
  let(:current_user){ admin }

  before do
    allow(controller).to receive(:current_user).and_return(current_user)
    request.env['HTTP_REFERER'] = admin_projects_path
  end

  describe 'PUT approve' do
    let(:project) { create(:project, state: 'in_analysis') }
    subject { project.online? }

    before do
      put :approve, id: project, locale: :pt
    end

    it do
      project.reload
      is_expected.to eq(true)
    end
  end

  describe 'PUT reject' do
    let(:project) { create(:project, state: 'in_analysis') }
    subject { project.rejected? }

    before do
      put :reject, id: project, locale: :pt
      project.reload
    end

    xit { is_expected.to eq(true) }
  end

  describe 'PUT push_to_draft' do
    let(:project) { create(:project, state: 'online') }
    subject { project.draft? }

    before do
      allow(controller).to receive(:current_user).and_return(admin)
      put :push_to_draft, id: project, locale: :pt
    end

    it do
      project.reload
      is_expected.to eq(true)
    end
  end

  describe 'PUT push_to_trash' do
    let(:project) { create(:project, state: 'draft') }
    subject{ project.reload.deleted? }

    before do
      allow(controller).to receive(:current_user).and_return(admin)
      put :push_to_trash, id: project, locale: :pt
    end

    it{ is_expected.to eq(true) }
  end


  describe "GET index" do
    context "when a user is not logged in" do
      let(:current_user){ nil }
      before do
        get :index, locale: :pt
      end
      it{ is_expected.to redirect_to new_user_registration_path }
    end

    context "when a user is logged as admin" do
      let!(:url_namespace_channel){ create(:channel) }
      let!(:out_of_channel_projects){ create_list(:project, 3) }
      let!(:channel_projects){ create_list(:project, 2, channels: [url_namespace_channel]) }
      let!(:channel_failed_project){ create(:project,  channels: [url_namespace_channel], state: 'deleted') }

      context 'is inside a channel' do
        before do
          allow(controller).to receive(:channel) { url_namespace_channel }
          get :index, locale: :pt
        end

        it "should return only projects registered on the admin's current channel" do
          expect(assigns(:projects)).to eq(channel_projects)
        end

        its(:status){ should == 200 }
      end

      context 'is not inside a channel' do
        before do
          allow(controller).to receive(:channel) { nil }
          get :index, locale: :pt
        end

        it 'should return all non-deleted projects' do
          expect(assigns(:projects)).to eq(out_of_channel_projects + channel_projects)
        end

        its(:status){ should == 200 }
      end
    end
  end

  describe '.collection' do
    let(:project) { create(:project, name: 'Project for search') }
    context "when there is a match" do
      before do
        get :index, locale: :pt, pg_search: 'Project for search'
      end
      it{ expect(assigns(:projects)).to eq([project]) }
    end

    context "when there is no match" do
      before do
        get :index, locale: :pt, pg_search: 'Foo Bar'
      end
      it{ expect(assigns(:projects)).to eq([]) }
    end
  end

  describe "DELETE destroy" do
    let(:project) { create(:project, state: 'draft') }

    context "when I'm not logged in" do
      let(:current_user){ nil }
      before do
        delete :destroy, id: project, locale: :pt
      end
      it{ is_expected.to redirect_to new_user_registration_path }
    end

    context "when I'm logged as admin" do
      before do
        delete :destroy, id: project, locale: :pt
      end

      its(:status){ should redirect_to admin_projects_path }

      it 'should change state to deleted' do
        expect(project.reload.deleted?).to eq(true)
      end
    end
  end

  describe "POST move_project_to_channel" do
    let (:project) { FactoryGirl.create(:project) }
    let (:channel) { FactoryGirl.create(:channel) }

    it "Adds project to channel" do
      expect(channel.projects).to be_empty

      post :move_project_to_channel, { :project_id => project.id, :channel_id => channel.id }

      expect(channel.reload.projects).to include(project)
    end
  end

end

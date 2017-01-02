require 'rails_helper'

RSpec.describe Project::Update do
  it_behaves_like 'when the validation of online_days needs to be done' do
    let(:service) { :update }
  end

  describe ".process" do
    let(:project) { create(:project, online_days: 10) }
    let(:params) { attributes_for(:project, online_days: 61) }
    let(:update_admin_service) { Project::Update.new(user, params, project) }
    let(:service_process) { update_admin_service.process }
    let(:project_with_61_online_days) { build(:project, online_days: 61) }

    before(:each) do
      service_process
    end

    describe "project.online_days" do
      context "when the user is a juntos' admin" do
        let(:user) { create(:user, admin: true) }

        context "when is greater than 0" do
          it "should return an updated project" do
            expect(update_admin_service.project.online_days).to eq 61
          end
        end
      end

      context "when the user is a common user" do
        let(:user) { create(:user, admin: false) }
        let(:persisted_project) { Project.find(update_admin_service.project.id) }

        context "when online_days has a value between 0 and 60" do
          let(:params) { attributes_for(:project, online_days: 60) }

          it "should return an updated project" do
            expect(persisted_project.online_days).to eq 60
          end
        end

        context "when online_days has a value greater than 61" do
          let(:params) { attributes_for(:project, online_days: 61) }

          it 'should not update the project' do
            expect(persisted_project.online_days).to eq 10
          end
        end
      end
    end
  end
end

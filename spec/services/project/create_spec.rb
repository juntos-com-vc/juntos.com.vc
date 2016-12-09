require 'rails_helper'

RSpec.describe Project::Create do
  it_behaves_like 'when the validation of online_days needs to be done' do
     let(:service) { :create }
  end

  describe ".process" do
    let(:create_admin_service) { Project::Create.new(user, project.attributes) }
    let(:service_process) { create_admin_service.process }
    let(:project_with_61_online_days) { build(:project, online_days: 61) }

    before(:each) do
      service_process
    end

    context "when the user is a juntos' admin" do
      let(:user) { create(:user, admin: true) }
      let(:project) { project_with_61_online_days }

      it "should create a project with any value greater than 0 for online_days" do
        expect(create_admin_service.project.id).to_not be_nil
      end
    end

    context "when the user is a common user" do
      let(:user) { create(:user, admin: false) }

      context "when online_days has a value greater than 0" do
        let(:project) { build(:project, online_days: 59) }

        it "must create the project" do
          expect(create_admin_service.project.id).to_not be_nil
        end
      end

      context "when online_days has a value greater than 61" do
        let(:project) { project_with_61_online_days }

        it "must not create the project" do
          expect(create_admin_service.project.id).to be_nil
        end
      end
    end
  end
end

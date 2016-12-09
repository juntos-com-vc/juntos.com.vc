RSpec.shared_examples 'when the validation of online_days needs to be done' do
  describe ".valid?" do
    let(:juntos_admin) { create(:user, admin: true) }
    let(:normal_user) { create(:user, admin: false) }

    let(:crud_service) {
      case service
      when :create
        Project::Create.new(user, project.attributes)
      when :update
        Project::Update.new(user, project.attributes, project)
      end
    }

    context "when the online days value passed is greater than 60" do
      let(:project) { build(:project, online_days: 61) }

      context "when the current user is a juntos' admin" do
        let(:user) { juntos_admin }

        it "should be valid" do
          expect(crud_service.valid?).to eq true
        end
      end

      context "when the current user is a project owner or the project channel owner" do
        let(:user) { normal_user }

        it "should be invalid" do
          expect(crud_service.valid?).to eq false
        end
      end
    end

    context "when the online days value passed is smaller than 60" do
      let(:project) { build(:project, online_days: 59) }

      context "when the current user is a juntos' admin" do
        let(:user) { juntos_admin }

        it "should be valid" do
          expect(crud_service.valid?).to eq true
        end
      end

      context "when the current user is a project owner or the project channel owner" do
        let(:user) { normal_user }

        it "should be valid" do
          expect(crud_service.valid?).to eq true
        end
      end
    end
  end
end

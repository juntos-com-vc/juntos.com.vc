require 'rails_helper'

RSpec.describe MoveProjectToChannel do
  describe "#call" do
    let (:project) { FactoryGirl.create(:project) }
    let (:channel) { FactoryGirl.create(:channel) }
    let (:project_with_channel) { FactoryGirl.create(:project_with_channel) }

    context "when project already has channel" do
      subject { MoveProjectToChannel.new(project_with_channel.id, channel.id) }

      it "doesn't add project to channel" do
        subject.call
        expect(project_with_channel.reload.channels).not_to include(channel)
      end
    end

    context "when a project doesn't have a channel" do
      subject { MoveProjectToChannel.new(project.id, channel.id) }
      it "adds project to channel" do
        subject.call
        expect(project.reload.channels).to include(channel)
      end

    end
  end
end

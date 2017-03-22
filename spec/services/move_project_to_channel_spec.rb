require 'rails_helper'

RSpec.describe MoveProjectToChannel do
  describe "#perform" do
    let(:project) { create(:project) }
    let(:channel) { create(:channel) }

    before do
      allow(project).to receive(:able_to_move_to_channel?).and_return(movable)
    end

    subject { MoveProjectToChannel.perform(project, channel) }

    context "when the project is able to move to channel" do
      let(:movable) { true }

      it "returns true" do
        is_expected.to eq(true)
      end

      it "moves the project to the new channel" do
        subject

        expect(project.reload.channels).to contain_exactly(channel)
      end
    end

    context "when the project is unable to move to channel" do
      let(:movable) { false }

      it "returns false" do
        is_expected.to eq(false)
      end

      it "does not move the project to the channel" do
        subject

        expect(project.reload.channels).not_to contain_exactly(channel)
      end
    end
  end
end

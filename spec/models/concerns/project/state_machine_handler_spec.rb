require 'rails_helper'

RSpec.describe Project::StateMachineHandler, type: :model do
  let(:user){ create(:user, full_name: 'Lorem Ipsum', cpf: '99999999999', phone_number: '99999999', moip_login: 'foobar') }

  describe "state machine" do
    let(:project) { create(:project, state: 'draft', online_date: nil, user: user) }

    describe "#send_to_analysis" do
      subject { project.in_analysis? }
      before do
        expect(project).to receive(:notify_observers).with(:from_draft_to_in_analysis).and_call_original
        project.send_to_analysis
      end

      it { is_expected.to eq(true) }

      it "should store sent_to_analysis_at" do
        expect(project.sent_to_analysis_at).to_not be_nil
      end
    end

    describe '#draft?' do
      subject { project.draft? }
      context "when project is new" do
        it { is_expected.to eq(true) }
      end
    end

    describe '.push_to_draft' do
      subject do
        project.reject
        project.push_to_draft
        project
      end
      its(:draft?){ should eq(true) }
    end

    describe '#rejected?' do
      subject { project.rejected? }
      before do
        project.send_to_analysis
        project.reject
      end
      context 'when project is not accepted' do
        it { is_expected.to eq(true) }
      end
    end

    describe '#reject' do
      before { project.update_attributes state: 'in_analysis' }
      subject do
        expect(project).to receive(:notify_observers).with(:from_in_analysis_to_rejected)
        project.reject
        project
      end
      its(:rejected?){ should eq(true) }
    end

    describe '#push_to_trash' do
      let(:project) { create(:project, permalink: 'my_project', state: 'draft') }

      subject do
        project.push_to_trash
        project
      end

      its(:deleted?) { should eq(true) }
      its(:permalink) { should == "deleted_project_#{project.id}" }
    end

    describe '#approve' do
      before { project.send_to_analysis }

      subject do
        expect(project).to receive(:notify_observers).with(:from_in_analysis_to_online)
        project.approve
        project
      end

      its(:online?){ should eq(true) }
      it('should call after transition method to notify the project owner'){ subject }
      it 'should persist the online_date' do
        project.approve
        expect(project.online_date).to_not be_nil
        expect(project.audited_user_name).to_not be_nil
        expect(project.audited_user_cpf).to_not be_nil
        expect(project.audited_user_moip_login).to_not be_nil
        expect(project.audited_user_phone_number).to_not be_nil
      end
    end

    describe '#online?' do
      before do
        project.send_to_analysis
        project.approve
      end
      subject { project.online? }
      it { is_expected.to eq(true) }
    end

    describe '#finish' do
      before { allow(project).to receive(:expired?).and_return(true) }

      context "when the project is online" do
        let(:project) { create(:project, :online) }

        context "and it has reached the goal" do
          before { allow(project).to receive(:reached_goal?).and_return(true) }

          context "and there is no waiting confirmation contributions" do
            before { allow(project).to receive(:in_time_to_wait?).and_return(false) }

            it "sets the project to successful" do
              project.finish

              expect(project.state).to eq 'successful'
            end
          end

          context "and there are waiting confirmation contributions" do
            before { allow(project).to receive(:pending_contributions_reached_the_goal?).and_return(true) }

            it "sets the project to waiting funds" do
              project.finish

              expect(project.state).to eq 'waiting_funds'
            end
          end
        end

        context "and it has not reached the goal" do
          before do
            allow(project).to receive(:should_fail?).and_return(true)
            allow(project).to receive(:pending_contributions_reached_the_goal?).and_return(false)
          end

          it "sets the project to failed" do
            project.finish

            expect(project.state).to eq 'failed'
          end
        end
      end

      context "when the project is waiting for funds" do
        let(:project) { create(:project, :waiting_funds) }

        context "and it has reached the goal" do
          before { allow(project).to receive(:reached_goal?).and_return(true) }

          context "and there is no waiting confirmation contributions" do
            before { allow(project).to receive(:in_time_to_wait?).and_return(false) }

            it "sets the project to successful" do
              project.finish

              expect(project.state).to eq 'successful'
            end
          end
        end

        context "and it has not reached the goal" do
          before { allow(project).to receive(:should_fail?).and_return(true) }

          context "and there is no waiting confirmation contributions" do
            before { allow(project).to receive(:in_time_to_wait?).and_return(false) }

            it "sets the project to failed" do
              project.finish

              expect(project.state).to eq 'failed'
            end
          end

          context "and there are waiting confirmation contributions" do
            before { allow(project).to receive(:in_time_to_wait?).and_return(true) }

            it "sets the project to waiting for funds" do
              project.finish

              expect(project.state).to eq 'waiting_funds'
            end
          end
        end
      end
    end
  end
end

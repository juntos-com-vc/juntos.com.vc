require 'rails_helper'

RSpec.describe Contribution, type: :model do
  include ActiveSupport::Testing::TimeHelpers

  let(:user){ create(:user) }
  let(:failed_project){ create(:project, state: 'online') }
  let(:unfinished_project){ create(:project, state: 'online') }
  let(:successful_project){ create(:project, state: 'online') }
  let(:unfinished_project_contribution){ create(:contribution, state: 'confirmed', user: user, project: unfinished_project) }
  let(:sucessful_project_contribution){ create(:contribution, state: 'confirmed', user: user, project: successful_project) }
  let(:not_confirmed_contribution){ create(:contribution, user: user, project: unfinished_project) }
  let(:valid_refund){ create(:contribution, state: 'confirmed', user: user, project: failed_project) }
  let(:contribution) { create(:contribution) }


  describe "Associations" do
    it { is_expected.to have_many(:payment_notifications) }
    it { is_expected.to belong_to(:project) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:reward) }
    it { is_expected.to belong_to(:country) }
    it { is_expected.to belong_to(:recurring_contribution) }
  end

  describe "Validations" do
    it{ is_expected.to validate_presence_of(:project) }
    it{ is_expected.to validate_presence_of(:user) }
    xit{ is_expected.to validate_presence_of(:value) }
    it{ is_expected.to allow_value(10).for(:value) }
    it{ is_expected.to allow_value(20).for(:value) }
  end

  describe "Custom validations" do
    let(:user) { create(:user) }
    describe "validates_numericality_of :value" do
      context "when user has credits" do
        let(:contribution) { build(:contribution, user: user) }

        before do
          allow(user).to receive(:credits).and_return(5)
          contribution.value = 5
          contribution.save
        end

        it { expect(contribution.valid?).to be_truthy }
        it { expect(contribution.errors).to be_empty }
      end

      context "when user not have credits" do
        let(:contribution) { build(:contribution, user: user) }

        before do
          allow(user).to receive(:credits).and_return(0)
          contribution.value = 5
          contribution.save
        end

        xit { expect(contribution.valid?).to be_falsey }
        xit { expect(contribution.errors).not_to be_empty }
      end
    end
  end

  describe ".avaiable_to_automatic_refund" do
    before do
      create(:contribution, state: 'confirmed', payment_choice: 'CartaoDeCredito', payment_method: nil)
      create(:contribution, state: 'confirmed', payment_choice: 'BoletoBancario', payment_method: 'Pagarme')
      create(:contribution, state: 'confirmed', payment_choice: nil, payment_method: 'PayPal')

      14.times { create(:contribution, state: 'confirmed', payment_choice: 'BoletoBancario', payment_method: 'MoIP') }
    end

    subject { Contribution.avaiable_to_automatic_refund }

    it { is_expected.to have(3).itens }
  end

  describe ".confirmed_state" do
    let(:contribution_confirmed_list) { create_list(:contribution, 3, state: 'confirmed') }

    before do
      create_list(:contribution, 3, :requested_refund)
      create_list(:contribution, 3, :refunded)
      create_list(:contribution, 3, :waiting_confirmation)
    end

    subject { Contribution.confirmed_state }

    it { is_expected.to match_array(contribution_confirmed_list) }
  end

  describe ".confirmed_today" do
    before do
      3.times { create(:contribution, state: 'confirmed', confirmed_at: 2.days.ago) }
      4.times { create(:contribution, state: 'confirmed', confirmed_at: 6.days.ago) }

      #TODO: need to investigate this timestamp issue when
      # use DateTime.now or Time.now
      7.times { create(:contribution, state: 'confirmed', confirmed_at: Time.now) }
    end

    subject { Contribution.confirmed_today }

    it { is_expected.to have(7).items }
  end

  describe ".between_values" do
    let(:start_at) { 10 }
    let(:ends_at) { 20 }
    subject { Contribution.between_values(start_at, ends_at) }
    before do
      create(:contribution, value: 10)
      create(:contribution, value: 15)
      create(:contribution, value: 20)
      create(:contribution, value: 21)
    end
    xit { is_expected.to have(3).itens }
  end

  describe ".can_cancel" do
    around do |test_case|
      travel_to(Time.new(2016, 11, 28)) { test_case.run }
    end
    after   { travel_back }
    subject { Contribution.can_cancel }

    context "when contribution is in time to wait the confirmation" do
      before do
        create(:contribution, :waiting_confirmation, created_at: 5.weekdays_ago)
        create(:contribution, :waiting_confirmation, created_at: 1.weekdays_ago)
      end

      it { is_expected.to have(0).item }
    end

    context "when we have contributions that are ahead of confirmation time" do
      before do
        create(:contribution, :waiting_confirmation, :slip_payment, created_at: 5.weekdays_ago)
        create(:contribution, :waiting_confirmation, :slip_payment, created_at: 3.weekdays_ago)
        create(:contribution, :waiting_confirmation, created_at: 4.weekdays_ago)
        create(:contribution, :waiting_confirmation, created_at: 5.weekdays_ago)
      end
      let!(:old_contribution) { create(:contribution, :waiting_confirmation, :slip_payment, created_at: 6.weekdays_ago) }

      it { is_expected.to contain_exactly(old_contribution) }
    end
  end

  describe '#slip_payment?' do
    subject { contribution.slip_payment? }

    context "when contribution is made with Boleto" do
      before do
        contribution.update_attributes payment_choice: 'BoletoBancario'
      end
      it { is_expected.to eq(true)}
    end

    context "when contribution is not made with Boleto" do
      before do
        contribution.update_attributes payment_choice: 'CartaoDeCredito'
      end
      it { is_expected.to eq(false)}
    end
  end

  describe '#recommended_projects' do
    subject{ contribution.recommended_projects }

    context "when we have another projects in the same category" do
      before do
        @recommended = create(:project, category: contribution.project.category)
        # add a project successful that should not apear as recommended
        create(:project, category: contribution.project.category, state: 'successful')
      end
      it{ is_expected.to eq [@recommended] }
    end

    context "when another user has contributed the same project" do
      before do
        @another_contribution = create(:contribution, project: contribution.project)
        @recommended = create(:contribution, user: @another_contribution.user).project
        # add a project successful that should not apear as recommended
        create(:contribution, user: @another_contribution.user, project: successful_project)
        successful_project.update_attributes state: 'successful'
      end
      it{ is_expected.to eq [@recommended] }
    end
  end


  describe ".can_refund" do
    subject{ Contribution.can_refund.load }
    before do
      create(:contribution, state: 'confirmed', credits: true, project: failed_project)
      valid_refund
      sucessful_project_contribution
      unfinished_project
      not_confirmed_contribution
      successful_project.update_attributes state: 'successful'
      failed_project.update_attributes state: 'failed'
    end
    it{ is_expected.to eq([valid_refund]) }
  end

  describe "#can_refund?" do
    subject{ contribution.can_refund? }
    before do
      valid_refund
      sucessful_project_contribution
      successful_project.update_attributes state: 'successful'
      failed_project.update_attributes state: 'failed'
    end

    context "when project is successful" do
      let(:contribution){ sucessful_project_contribution }
      it{ is_expected.to eq(false) }
    end

    context "when project is not finished" do
      let(:contribution){ unfinished_project_contribution }
      it{ is_expected.to eq(false) }
    end

    context "when contribution is not confirmed" do
      let(:contribution){ not_confirmed_contribution }
      it{ is_expected.to eq(false) }
    end

    context "when it's a valid refund" do
      let(:contribution){ valid_refund }
      xit{ is_expected.to eq(true) }
    end
  end

  describe "#credits" do
    subject{ user.credits.to_f }
    context "when contributions are confirmed and not done with credits but project is successful" do
      before do
        create(:contribution, state: 'confirmed', user: user, project: successful_project)
        successful_project.update_attributes state: 'successful'
      end
      it{ is_expected.to eq(0) }
    end

    context "when contributions are confirmed and not done with credits" do
      before do
        create(:contribution, state: 'confirmed', user: user, project: failed_project)
        failed_project.update_attributes state: 'failed'
        user.reload
      end
      it{ is_expected.to eq(10) }
    end

    context "when contributions are done with credits" do
      before do
        create(:contribution, credits: true, state: 'confirmed', user: user, project: failed_project)
        failed_project.update_attributes state: 'failed'
      end
      it{ is_expected.to eq(0) }
    end

    context "when contributions are not confirmed" do
      before do
        create(:contribution, user: user, project: failed_project, state: 'pending')
        failed_project.update_attributes state: 'failed'
      end
      it{ is_expected.to eq(0) }
    end
  end

  describe '.only_recurring' do
    subject { Contribution.only_recurring }

    context 'when we dont have any recurring contribution' do
      it { is_expected.to have(0).item }
    end

    context 'when we have recurring contributions' do
      before do
        recurring_contribution = create(:recurring_contribution, contributions: [contribution])
        contribution.update_attributes(recurring_contribution: recurring_contribution)
      end

      it { is_expected.to have(1).item }
    end
  end

  describe '.only_cancelled_recurring' do
    subject { Contribution.only_recurring }

    context 'when we dont have any cancelled recurring contribution' do
      it { is_expected.to have(0).item }
    end

    context 'when we have cancelled recurring contributions' do
      before do
        recurring_contribution = create(:recurring_contribution, contributions: [contribution], cancelled_at: Time.now)
        contribution.update_attributes(recurring_contribution: recurring_contribution)
      end

      it { is_expected.to have(1).item }
    end
  end

  describe '#with_cause' do
    let(:category) { create(:category) }
    let(:project) { create(:project) }

    before do
      create(:contribution, project: project, payer_email: 'test1@test.com')
      create(:contribution, project: project, payer_email: 'test2@test.com')
      create(:contribution, project: project, payer_email: 'test3@test.com')
      create(:contribution, payer_email: 'test4@test.com')
    end

    context 'when category does not have a project' do
      it 'does not find a contributions having the category as a cause' do
        contributions = Contribution.with_cause(category.id)
        expect(contributions).to have(0).items
      end
    end

    context 'when category have registered projects' do
      before do
        @contributions = Contribution.with_cause(project.category_id)
        @payer_emails = @contributions.map(&:payer_email)
      end

      it 'does find contributions having the category as a cause' do
        expect(@payer_emails).to match_array(['test1@test.com', 'test2@test.com', 'test3@test.com'])
      end

      it 'ommits contributions without the category as a cause' do
        expect(@payer_emails).not_to include('test4@test.com')
      end
    end
  end

  describe '#project_name_contains' do
    let(:great_name_project){ create(:project, name: 'Great project') }
    let(:great_headline_project){ create(:project, headline: 'Great project') }
    let(:great_permalink_project){ create(:project, permalink: 'great') }
    let(:great_project_contributions){ Contribution.project_name_contains('great') }

    before(:each) do
      create(:contribution, project: great_name_project, project_value: 50)
      create(:contribution, project: great_headline_project, project_value: 40)
      create(:contribution, project: great_permalink_project, project_value: 30)
    end

    context 'when there are contributions made to project that matches the term searched' do
      it 'returns the contributions made to project found' do
        expect(great_project_contributions.map(&:project_value)).to contain_exactly(40.0, 30.0, 50.0)
      end

      it "returns the contributions in the right order of Project.search_on_name's against param rules" do
        all_great_project_contributions = great_project_contributions.map { |c| c.project_value.to_f }
        expect(all_great_project_contributions).to eq([50.0, 40.0, 30.0])
      end
    end

    context 'when contributions to a project that name matches the term searched do not exist' do
      it 'does not return contributions' do
        cool_project_contributions = Contribution.project_name_contains('cool')
        expect(cool_project_contributions).to be_empty
      end
    end
  end
end

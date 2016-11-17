# coding: utf-8
require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe Project, type: :model do
  include ActiveSupport::Testing::TimeHelpers

  subject(:project)     { create(:project) }
  let(:user)            { create(:user) }
  let(:channel)         { create(:channel, users: [ user ]) }
  let(:channel_project) { create(:project, channels: [ channel ]) }

  describe "associations" do
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :category }
    it { is_expected.to have_one  :project_total }
    it { is_expected.to have_many :rewards }
    it { is_expected.to have_many :contributions }
    it { is_expected.to have_many :posts }
    it { is_expected.to have_many :unsubscribes }
    it { is_expected.to have_many :project_images }
    it { is_expected.to have_many :project_partners }
    it { is_expected.to have_many :subgoals }
    it { is_expected.to have_many :notifications }
    it { is_expected.to have_and_belong_to_many :channels }
  end

  describe "validations" do
    describe "presence validations" do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:user) }
      it { is_expected.to validate_presence_of(:permalink) }
      it { is_expected.to validate_presence_of(:about) }
      it { is_expected.to validate_presence_of(:category) }
    end

    describe "online_days acceptance validations" do
      it { is_expected.to     allow_value(1).for(:online_days) }
      it { is_expected.not_to allow_value(0).for(:online_days) }
      it { is_expected.not_to allow_value(61).for(:online_days) }
    end

    describe "video_url acceptance validations" do
      it { is_expected.to     allow_value('http://vimeo.com/12111').for(:video_url) }
      it { is_expected.to     allow_value('vimeo.com/12111').for(:video_url) }
      it { is_expected.to     allow_value('https://vimeo.com/12111').for(:video_url) }
      it { is_expected.to     allow_value('http://youtube.com/watch?v=UyU-xI').for(:video_url) }
      it { is_expected.to     allow_value('youtube.com/watch?v=UyU-xI').for(:video_url) }
      it { is_expected.to     allow_value('https://youtube.com/watch?v=UyU-xI').for(:video_url) }
      it { is_expected.not_to allow_value('http://www.foo.bar').for(:video_url) }
    end

    describe "goal acceptance validations" do
      it { is_expected.to     allow_value(10).for(:goal) }
      it { is_expected.not_to allow_value(8).for(:goal) }
    end

    describe "permalink acceptance validations" do
      it { is_expected.to      allow_value('testproject').for(:permalink) }
      it { is_expected.not_to allow_value('@users').for(:permalink) }
    end

    describe "numericality validations" do
      it { is_expected.to validate_numericality_of(:goal) }
    end

    describe "length of validations" do
      it { is_expected.to ensure_length_of(:headline).is_at_most(140).is_at_least(1) }
    end
  end

  describe ".search_on_name" do
    before do
      category = create(:category, name_pt: 'teste_pt', name_en: 'test_en')
      create(:project, name: 'project_name', category: category)
      create(:project, name: 'foo_1')
      create(:project, name: 'foo_2')
    end

    context "when project is found" do
      context "and it searches on category name" do
        context "and it's in portuguese" do
          subject { Project.search_on_name('teste_pt').map(&:name) }

          it { is_expected.to contain_exactly('project_name') }
        end

        context "and it's in english" do
          subject { Project.search_on_name('test_en').map(&:name) }

          it { is_expected.to contain_exactly('project_name') }
        end
      end

      context "and it searches on project name" do
        subject { Project.search_on_name('project_name').map(&:name) }

        it { is_expected.to contain_exactly('project_name') }

        context "and the search ignores accents" do
          subject { Project.search_on_name('prôject_nãmé').map(&:name) }

          it { is_expected.to contain_exactly('project_name') }
        end
      end
    end

    context "when project is not found" do
      subject{ Project.search_on_name('lorem') }

      it{ is_expected.to be_empty }
    end
  end

  describe ".pg_search" do
    let(:user)     { create(:user, name: 'fulano', address_city: 'some_address_far_away') }
    let(:category) { create(:category, name_pt: 'teste_pt', name_en: 'test_en') }
    let!(:project) { create(:project, name: 'foo', category: category, user: user) }

    context "when project is found" do
      context "and it searches on category name" do
        context "and it's in portuguese" do
          subject { Project.pg_search('teste_pt').map(&:name) }

          it { is_expected.to contain_exactly(project.name) }
        end

        context "and it's in english" do
          subject { Project.pg_search('test_en').map(&:name) }

          it { is_expected.to contain_exactly(project.name) }
        end
      end

      context "and it searches on user" do
        context "name field" do
          subject { Project.pg_search('fulano').map(&:name) }

          it { is_expected.to contain_exactly(project.name) }
        end

        context "address_city field" do
          subject { Project.pg_search('some_address_far_away').map(&:name) }

          it { is_expected.to contain_exactly(project.name) }
        end
      end

      context "and it searches on project name" do
        subject { Project.pg_search('foo').map(&:name) }

        it { is_expected.to contain_exactly(project.name) }

        context "and the search ignores accents" do
          subject { Project.pg_search('fóõ').map(&:name) }

          it { is_expected.to contain_exactly(project.name) }
        end
      end
    end

    context "when project is not found" do
      subject{ Project.pg_search('lorem') }

      it{ is_expected.to be_empty }
    end
  end

  describe ".user_name_contains" do
    let(:user) { create(:user, name: 'fulano', address_city: 'some_address_far_away') }
    before     { create(:project, name: 'fulanos_project', user: user) }

    context "when project is found" do
      subject { Project.user_name_contains('fulano').map(&:name) }

      it { is_expected.to contain_exactly('fulanos_project') }

      context "and the search ignores accents" do
        subject { Project.user_name_contains('fūlåñö').map(&:name) }

        it { is_expected.to contain_exactly('fulanos_project') }
      end
    end

    context "when project is not found" do
      subject { Project.user_name_contains('user_does_not_exist').map(&:name) }

      it { is_expected.to be_empty }
    end
  end

  describe ".successful" do
    before do
      create(:project, :successful, name: 'successful_project_1')
      create(:project, :successful, name: 'successful_project_2')
      create(:project, :online)
      create(:project, :failed)
      create(:project, :draft)
      create(:project, :rejected)
      create(:project, :deleted)
      create(:project, :in_analysis)
    end

    subject { Project.successful.map(&:name) }

    it { is_expected.to contain_exactly('successful_project_1', 'successful_project_2') }
  end

  describe ".failed" do
    before do
      create(:project, :failed, name: 'failed_project_1')
      create(:project, :failed, name: 'failed_project_2')
      create(:project, :successful)
      create(:project, :online)
      create(:project, :draft)
      create(:project, :rejected)
      create(:project, :deleted)
      create(:project, :in_analysis)
    end

    subject { Project.failed.map(&:name) }

    it { is_expected.to contain_exactly('failed_project_1', 'failed_project_2') }
  end

  describe ".draft" do
    before do
      create(:project, :draft, name: 'draft_1')
      create(:project, :draft, name: 'draft_2')
      create(:project, :failed)
      create(:project, :successful)
      create(:project, :online)
      create(:project, :rejected)
      create(:project, :deleted)
      create(:project, :in_analysis)
    end

    subject { Project.draft.map(&:name) }

    it { is_expected.to contain_exactly('draft_1', 'draft_2') }
  end

  describe ".with_project_totals" do
    before  do
      project = create(:project, name: 'with_project_totals')
      create(:contribution, project: project)
    end

    subject { Project.with_project_totals.map(&:name) }

    it { is_expected.to contain_exactly('with_project_totals') }
  end

  describe ".without_pepsico_channel" do
    let(:channel) { create(:channel) }
    before { create(:project, name: 'without_pepsico', channels: [channel]) }

    subject { Project.without_pepsico_channel.map(&:name) }

    context "when the permalink is not 'pepsico'" do
      it { is_expected.to contain_exactly('without_pepsico') }
    end

    context "when the permalink is 'pepsico'" do
      let(:channel) { create(:channel, permalink: 'pepsico') }

      it { is_expected.to be_empty }
    end
  end

  describe ".draft_and_without_channel" do
    let(:channel) { create(:channel) }
    subject       { Project.draft_and_without_channel.map(&:name) }

    context "when project state is 'draft'" do
      context "and it has no channel" do
        before { create(:project, :draft, name: 'draft_project') }

        it { is_expected.to contain_exactly('draft_project') }
      end

      context "and it has channel" do
        before { create(:project, :draft, channels: [channel]) }

        it { is_expected.to be_empty }
      end
    end

    context "when project state is not 'draft'" do
      before { create(:project, :online) }

      it { is_expected.to be_empty }
    end
  end

  describe ".by_progress" do
    let(:fifth_percent) { 50 }
    let(:project)       { create(:project, name: 'project_in_progress', goal: 100) }

    subject { Project.by_progress(fifth_percent).map(&:name) }

    context "when project value is smaller than half goal" do
      before { create(:contribution, project: project, project_value: 10) }

      it { is_expected.to be_empty }
    end

    context "when project value is greater than half goal" do
      before { create(:contribution, project: project, project_value: 51) }

      it { is_expected.to contain_exactly('project_in_progress') }
    end
  end

  describe ".by_channel" do
    let(:channel) { create(:channel) }

    subject { Project.by_channel(channel).map(&:name) }

    context "when a project has the channel" do
      before { create(:project, name: 'project_by_channel', channels: [channel]) }

      it { is_expected.to contain_exactly('project_by_channel') }
    end

    context "when a project has not the channel" do
      before { create(:project) }

      it { is_expected.to be_empty }
    end
  end

  describe ".by_user_email" do
    let(:user_email) { 'user_email_@test.com' }
    let(:user) { create(:user, email: user_email) }

    subject { Project.by_user_email(user_email).map(&:name) }

    context "when project belongs to the user" do
      before { create(:project, name: 'project_user', user: user) }

      it { is_expected.to contain_exactly('project_user') }
    end

    context "when project does not belong to the user" do
      let!(:project) { create(:project) }

      it { is_expected.to be_empty }
    end
  end

  describe ".by_id" do
    subject { Project.by_id(10003).map(&:name) }

    context "when the project id is 10003" do
      before { create(:project, name: 'id_10003', id: 10003) }

      it { is_expected.to contain_exactly('id_10003') }
    end

    context "when the project id is not 10003" do
      before { create(:project, id: 1002) }

      it { is_expected.to be_empty }
    end
  end

  describe ".by_goal" do
    subject { Project.by_goal(1009).map(&:name) }

    context "when project goal is 1009" do
      before { create(:project, name: 'goal_1009', goal: 1009) }

      it { is_expected.to contain_exactly('goal_1009') }
    end

    context "when project goal is not 1009" do
      before { create(:project, goal: 1234) }

      it { is_expected.to be_empty }
    end
  end

  describe ".by_category_id" do
    let(:category) { create(:category, id: 2001) }
    subject        { Project.by_category_id(2001).map(&:name) }

    context "when category id is 2001" do
      before { create(:project, name: 'project_category_2001', category: category) }

      it { is_expected.to contain_exactly('project_category_2001') }
    end

    context "when category id is not 2001" do
      before { create(:project) }

      it { is_expected.to be_empty }
    end
  end

  describe ".by_online_date" do
    let(:online_date) { Time.current }
    subject { Project.by_online_date(online_date).map(&:name) }

    context "when online_date is today" do
      before { create(:project, name: 'project_today', online_date: online_date) }

      it { is_expected.to contain_exactly('project_today') }
    end

    context "when online_date is not today" do
      before { create(:project, online_date: 5.days.from_now) }

      it { is_expected.to be_empty }
    end
  end

  describe ".by_expires_at" do
    before             { travel_to Time.new(2016, 11, 28, 10, 00, 00) }
    after              { travel_back }
    let(:expires_at)   { 2.day.from_now.utc.to_date }
    subject            { Project.by_expires_at(expires_at).map(&:name) }

    context "when expires next day" do
      before { create(:project, name: 'project_next_day', online_date: Time.current.utc, online_days: 1) }

      it { is_expected.to contain_exactly('project_next_day') }
    end

    context "when does not expire next day" do
      before { create(:project, online_date: Time.current.utc, online_days: 5) }

      it { is_expected.to be_empty }
    end
  end

  describe ".by_updated_at" do
    let(:updated_at) { Time.current }
    subject { Project.by_updated_at(updated_at).map(&:name) }

    context "when project updated_at is now" do
      before { create(:project, name: 'project_updated_at', updated_at: updated_at) }

      it { is_expected.to contain_exactly('project_updated_at') }
    end

    context "when project updated_at is not now" do
      before { create(:project, updated_at: 5.days.from_now) }

      it { is_expected.to be_empty }
    end
  end

  describe ".by_permalink" do
    subject{ Project.by_permalink('foo').map(&:name) }

    context "when permalink is found" do
      context "when project is deleted" do
        before { create(:project, :deleted, permalink: 'foo') }

        it { is_expected.to be_empty }
      end

      context "when project is not deleted" do
        before { create(:project, name: 'project_permalink', permalink: 'foo') }

        it { is_expected.to contain_exactly('project_permalink') }
      end
    end

    context "when permalink is not found" do
      before { create(:project, :deleted, permalink: 'bar') }

      it { is_expected.to be_empty }
    end
  end

  describe ".recommended" do
    subject { Project.recommended.map(&:name) }

    context "when the project is recommended" do
      before { create(:project, name: 'recommended_project', recommended: true) }

      it { is_expected.to contain_exactly('recommended_project') }
    end

    context "when the project is not recommended" do
      before { create(:project, recommended: false) }

      it { is_expected.to be_empty }
    end
  end

  describe ".in_funding" do
    subject { Project.in_funding.map(&:name) }

    context "when project is expired" do
      before { create(:project, online_date: 2.days.ago, online_days: 1) }

      it { is_expected.to be_empty }
    end

    context "when project is not expired" do
      context "and state is online" do
        before { create(:project, :online, name: 'project_in_funding') }

        it { is_expected.to contain_exactly('project_in_funding') }
      end

      context "and state is not online" do
        before { create(:project, :draft, name: 'project_in_funding') }

        it { is_expected.to be_empty }
      end
    end
  end

  describe ".name_contains" do
    subject { Project.name_contains('project_name').map(&:name) }

    context "when project name is found" do
      context "and it is exactly the same" do
        before { create(:project, name: 'project_name') }

        it { is_expected.to contain_exactly('project_name') }
      end

      context "and it contains more characters" do
        before { create(:project, name: 'it is has bigger project_name than search criteria') }

        it { is_expected.to contain_exactly('it is has bigger project_name than search criteria') }
      end

      context "and it is a mix of upper and lower cases" do
        before { create(:project, name: 'PrOjeCt_nAMe') }

        it { is_expected.to contain_exactly('PrOjeCt_nAMe') }
      end
    end

    context "when project name is not found" do
      before { create(:project, name: 'test_some_name') }

      it { is_expected.to be_empty }
    end
  end

  describe ".near_of" do
    subject { Project.near_of('RN').map(&:name) }

    context "when project is found" do
      before do
        user = create(:user, address_state: 'RN')
        create(:project, name: 'project_near_of', user: user)
      end

      it { is_expected.to contain_exactly('project_near_of') }
    end

    context "when project is not found" do
      before do
        user = create(:user, address_state: 'SP')
        create(:project, user: user)
      end

      it { is_expected.to be_empty }
    end
  end

  describe '.to_finish' do
    subject { Project.to_finish.map(&:name) }

    context "when project is found" do
      context "and is expired" do
        context "and state is 'online' or 'waiting_funds'" do
          before do
            create(:project, :online, name: 'project_to_finish_1', online_date: 10.days.ago, online_days: 1)
            create(:project, :waiting_funds, name: 'project_to_finish_2', online_date: 10.days.ago, online_days: 1)
          end

          it { is_expected.to contain_exactly('project_to_finish_1', 'project_to_finish_2') }
        end

        context "and state is not 'online' nor 'waiting_funds'" do
          before do
            create(:project, :rejected, online_date: Date.current, online_days: 4)
            create(:project, :failed, online_date: Date.current, online_days: 4)
            create(:project, :deleted, online_date: Date.current, online_days: 4)
            create(:project, :successful, online_date: Date.current, online_days: 4)
          end

          it { is_expected.to be_empty }
        end
      end

      context "and is not expired" do
        before { create(:project, online_date: Date.current, online_days: 10) }

        it { is_expected.to be_empty }
      end
    end
  end

  describe ".visible" do
    subject { Project.visible.map(&:name) }

    context "when the projects are visible" do
      before do
        create(:project, :online, name: 'online')
        create(:project, :successful, name: 'successful')
        create(:project, :failed, name: 'failed')
        create(:project, :waiting_funds, name: 'waiting_funds')
      end

      it { is_expected.to contain_exactly('online', 'successful', 'failed', 'waiting_funds') }
    end

    context "when the projects are not visible" do
      before do
        create(:project, :draft)
        create(:project, :rejected)
        create(:project, :deleted)
        create(:project, :in_analysis)
      end

      it { is_expected.to be_empty }
    end
  end

  describe ".financial" do
    subject { Project.financial.map(&:name) }

    context "when the projects are found" do
      context "when state is 'online', 'successful' or 'waiting_funds'" do
        context "when the project has expired for less than 15 days or is not expired" do
          before do
            create(:project, :online, name: 'financial_project_1', online_date: 15.days.ago, online_days: 2)
            create(:project, :successful, name: 'financial_project_2', online_date: Date.current, online_days: 2)
            create(:project, :waiting_funds, name: 'financial_project_3')
          end

          it { is_expected.to contain_exactly('financial_project_1', 'financial_project_2', 'financial_project_3') }
        end

        context "when the project is expired for 15 or more days" do
          before do
            create(:project, :online, online_date: 20.days.ago, online_days: 4)
            create(:project, :successful, online_date: 20.days.ago, online_days: 4)
            create(:project, :waiting_funds, online_date: 20.days.ago, online_days: 4)
          end

          it { is_expected.to be_empty }
        end
      end

      context "when state is not 'online', 'successful' nor 'waiting_funds'" do
        before do
          create(:project, :failed)
          create(:project, :deleted)
          create(:project, :rejected)
          create(:project, :in_analysis)
        end

        it { is_expected.to be_empty }
      end
    end
  end

  describe ".expired" do
    subject { Project.expired.map(&:name) }

    context "when project is expired" do
      before { create(:project, name: 'expired_project', online_date: 2.days.ago, online_days: 1) }

      it { is_expected.to contain_exactly('expired_project') }
    end

    context "when project is not expired" do
      before { create(:project, online_date: Date.current, online_days: 15) }

      it { is_expected.to be_empty }
    end
  end

  describe ".not_expired" do
    subject { Project.not_expired.map(&:name) }

    context "when project is not expired" do
      before { create(:project, name: 'not_expired_project', online_date: Date.current, online_days: 2) }

      it { is_expected.to contain_exactly('not_expired_project') }
    end

    context "when project is expired" do
      before { create(:project, online_days: 1, online_date: Date.current - 2.days) }

      it { is_expected.to be_empty }
    end
  end

  describe ".expiring" do
    subject { Project.expiring.map(&:name) }

    context "when project is expiring in two weeks" do
      before { create(:project, name: 'expiring_project', online_date: Date.current, online_days: 13) }

      it { is_expected.to contain_exactly('expiring_project') }
    end

    context "when project expires_at is longer than two weeks" do
      before { create(:project, online_date: Date.current, online_days: 50) }

      it { is_expected.to be_empty }
    end

    context "when project is already expired" do
      before { create(:project, online_date: 10.days.ago, online_days: 1) }

      it { is_expected.to be_empty }
    end
  end

  describe ".not_expiring" do
    subject { Project.not_expiring.map(&:name) }

    context "when there are no projects expiring" do
      before { create(:project, name: 'not_expiring_project', online_date: Date.current, online_days: 15) }

      it { is_expected.to contain_exactly('not_expiring_project') }
    end

    context "when there are projects expiring" do
      before { create(:project, online_date: 2.days.ago, online_days: 1) }

      it { is_expected.to be_empty }
    end
  end

  describe ".recent" do
    subject { Project.recent.map(&:name) }

    context "when there are recent projects" do
      before { create(:project, name: '4_days_ago', online_date: 4.days.ago) }

      it { is_expected.to contain_exactly('4_days_ago') }
    end

    context "when there is no project created in the last 6 days" do
      before { create(:project, online_date: 6.days.ago) }

      it { is_expected.to be_empty }
    end
  end

  describe ".order_status" do
    subject { Project.order_status.map(&:name) }

    before {
      create(:project, :waiting_funds, name: 'waiting_funds')
      create(:project, :online, name: 'online')
      create(:project, :failed, name: 'failed')
      create(:project, :successful, name: 'successful')
    }

    it { is_expected.to contain_exactly('online', 'waiting_funds', 'successful', 'failed') }
  end

  describe ".most_recent_first" do
    subject { Project.most_recent_first.map(&:name) }

    before do
      create(:project, name: 'project_2', online_date: Date.current)
      create(:project, name: 'project_4', online_date: 10.days.ago)
      create(:project, name: 'project_3', online_date: 4.days.ago)
      create(:project, name: 'project_1', online_date: 4.days.from_now)
    end

    it { is_expected.to contain_exactly('project_1', 'project_2', 'project_3', 'project_4') }
  end

  describe ".order_for_admin" do
    subject { Project.order_for_admin.map(&:name) }

    before {
      create(:project, :waiting_funds, name: 'waiting_funds')
      create(:project, :online, name: 'in_analysis')
      create(:project, :failed, name: 'failed')
      create(:project, :successful, name: 'successful')
    }

    it { is_expected.to contain_exactly('in_analysis', 'waiting_funds', 'successful', 'failed') }
  end

  describe ".from_channels" do
    let(:channel) { create(:channel) }
    subject       { Project.from_channels(channel.id).map(&:name) }

    context "when the project could be found by the channel" do
      before { create(:project, name: 'project_by_channel', channels: [channel]) }

      it { is_expected.to contain_exactly('project_by_channel') }
    end

    context "when the project could not be found by the channel" do
      before { create(:project) }

      it { is_expected.to be_empty }
    end
  end

  describe ".with_contributions_confirmed_today" do
    let(:project_01) { create(:project, :online, name: 'with_contribution_1') }
    let(:project_02) { create(:project, :online, name: 'with_contribution_2') }
    let(:project_03) { create(:project, :online) }

    subject { Project.with_contributions_confirmed_today.map(&:name) }

    context "when have confirmed contributions today" do
      before do
        create(:contribution, :confirmed, project: project_01, confirmed_at: Time.current )
        create(:contribution, :confirmed, project: project_02, confirmed_at: Time.current )
        create(:contribution, :confirmed, project: project_03, confirmed_at: 2.days.ago )
      end

      it { is_expected.to contain_exactly('with_contribution_1', 'with_contribution_2') }
    end

    context "when does not have any confirmed contribution today" do
      before do
        create(:contribution, :confirmed, project: project_01, confirmed_at: 1.days.ago )
        create(:contribution, :confirmed, project: project_02, confirmed_at: 2.days.ago )
        create(:contribution, :confirmed, project: project_03, confirmed_at: 5.days.ago )
      end

      it { is_expected.to be_empty }
    end
  end

  describe ".expiring_in_less_of" do
    subject { Project.expiring_in_less_of('7 days').map(&:name) }

    context "when the project is online" do
      context "when expiring date is in less than 7 days" do
        before do
          create(:project, :online, name: 'expires_in_3_days', online_date: DateTime.current, online_days: 3)
          create(:project, :online, name: 'expires_in_5_days', online_date: DateTime.current, online_days: 5)
        end

        it { is_expected.to contain_exactly('expires_in_3_days', 'expires_in_5_days') }
      end

      context "when expiring date is over 7 days" do
        before do
          create(:project, :online, online_date: DateTime.current, online_days: 30)
          create(:project, :draft)
        end

        it { is_expected.to be_empty }
      end
    end

    context "when the project is not online" do
      before do
        create(:project, :failed)
        create(:project, :draft)
        create(:project, :rejected)
      end

      it { is_expected.to be_empty }
    end
  end

  describe ".of_current_week" do
    subject { Project.of_current_week.map(&:name) }

    context "when the online_date is any day from last week" do
      before do
        create(:project, name: 'today', online_date: DateTime.current)
        create(:project, name: 'in_3_days', online_date: 3.days.from_now)
        create(:project, name: 'in_30_days', online_date: 30.days.from_now)
        create(:project, name: 'six_days_ago', online_date: 6.days.ago)
      end

      it { is_expected.to contain_exactly('today', 'in_3_days', 'in_30_days', 'six_days_ago') }
    end

    context "when the online_date is earlier than last week" do
      before do
        create(:project, online_date: 9.year.ago)
        create(:project, online_date: 8.days.ago)
        create(:project, online_date: 10.weeks.ago)
      end

      it { is_expected.to be_empty }
    end
  end

  describe '.recurring' do
    let(:channel)               { create :channel, recurring: true }
    let(:channel_not_recurring) { create :channel }
    subject { Project.recurring.map(&:name) }

    context "when there are recurring projects" do
      before do
        create(:project, name: 'recurring_project_1', channels: [channel], category: nil)
        create(:project, name: 'recurring_project_2', channels: [channel], category: nil)
      end

      it { is_expected.to contain_exactly('recurring_project_1', 'recurring_project_2') }
    end

    context "when there are not recurring_projects" do
      before do
        create(:project, channels: [channel_not_recurring])
        create(:project, channels: [channel_not_recurring])
      end

      it { is_expected.to be_empty }
    end
  end

  describe '.with_channel_without_recurring' do
    let(:channel)               { create :channel, recurring: true }
    let(:channel_not_recurring) { create :channel }
    subject { Project.with_channel_without_recurring.map(&:name) }

    context "when there are recurring projects" do
      before do
        create(:project, channels: [channel], category: nil)
        create(:project, channels: [channel], category: nil)
      end

      it { is_expected.to be_empty }
    end

    context "when there are not recurring_projects" do
      before do
        create(:project, name: 'normal_project_1', channels: [channel_not_recurring])
        create(:project, name: 'normal_project_2', channels: [channel_not_recurring])
      end

      it { is_expected.to contain_exactly('normal_project_1', 'normal_project_2') }
    end
  end

  describe ".without_channel" do
    subject { Project.without_channel.map(&:name) }

    context "when there are projects without channel" do
      before do
        create(:project, name: 'project_1')
        create(:project, name: 'project_2')
        create(:project, name: 'project_3')
      end

      it { is_expected.to contain_exactly('project_1', 'project_2', 'project_3') }
    end

    context "when there are projects with channel" do
      before do
        create(:project_with_channel)
        create(:project_with_channel)
        create(:project_with_channel)
      end

      it { is_expected.to be_empty }
    end
  end

  describe ".without_recurring_and_pepsico_channel" do
    let(:channel)           { create(:channel) }
    let(:recurring_channel) { create(:channel, recurring: true) }
    let(:channel_pepsico)     { create(:channel, permalink: 'pepsico') }
    subject { Project.without_recurring_and_pepsico_channel.map(&:name) }

    context "when there are projects not recurring" do
      context "and the project has channel" do
        context "and the channel is not pepsico" do
          before { create(:project, name: 'project_with_channel', channels: [channel]) }

          it { is_expected.to contain_exactly('project_with_channel') }
        end

        context "and the channel is pepsico" do
          before { create(:project, channels: [channel_pepsico]) }

          it { is_expected.to be_empty }
        end
      end

      context "and the project has no channel" do
        before { create(:project, name: 'project_without_channel') }

        it { is_expected.to contain_exactly('project_without_channel') }
      end
    end

    context "when there are recurring projects" do
      before { create(:project, channels: [recurring_channel], category: nil ) }

      it { is_expected.to be_empty }
    end
  end

  describe '.goal_between' do
    before do
      create(:project, goal: 199, name: 'with_goal_199')
      create(:project, goal: 200, name: 'with_goal_200')
      create(:project, goal: 300, name: 'with_goal_300')
      create(:project, goal: 400, name: 'with_goal_400')
      create(:project, goal: 401, name: 'with_goal_401')
    end

    subject { Project.goal_between(start_at, ends_at).map(&:name) }

    context "when there are both start_at and ends_at" do
      let(:start_at) { 200 }
      let(:ends_at)  { 300 }

      it { is_expected.to contain_exactly('with_goal_200', 'with_goal_300') }
    end

    context "when there is only ends_at filter" do
      let(:start_at) { nil }
      let(:ends_at)  { 300 }

      it { is_expected.to contain_exactly('with_goal_199', 'with_goal_200', 'with_goal_300') }
    end

    context "when there is only start_at filter" do
      let(:start_at) { 200 }
      let(:ends_at)  { nil }

      it { is_expected.to contain_exactly('with_goal_200', 'with_goal_300', 'with_goal_400', 'with_goal_401') }
    end

    context "when there is neither start_at and ends_at" do
      let(:start_at) { nil }
      let(:ends_at)  { nil }

      it { is_expected.to contain_exactly('with_goal_199', 'with_goal_200', 'with_goal_300', 'with_goal_400', 'with_goal_401') }
    end
  end

  describe '.state_names' do
    let(:states) { [:draft, :rejected, :online, :successful, :waiting_funds, :failed, :in_analysis] }

    subject { Project.state_names }

    it { is_expected.to eq(states) }
  end

  describe '.video_url' do
    subject { project }

    before do
      CatarseSettings[:minimum_goal_for_video] = 5000
    end

    context 'when goal is above minimum' do
      context 'and project is online' do
        let(:project) { create :project, goal: 6000, state: 'online' }

        it { is_expected.not_to allow_value(nil).for(:video_url) }
      end

      context 'and project is in analysis' do
        let(:project) { create :project, goal: 6000, state: 'in_analysis' }

        it { is_expected.not_to allow_value(nil).for(:video_url) }
      end
    end

    context 'when goal is below minimum' do
      context 'and project is online' do
        let(:project) { create :project, goal: 4000, state: 'online' }

        it { is_expected.to allow_value(nil).for(:video_url) }
      end

      context 'and project is in analysis' do
        let(:project) { create :project, goal: 4000, state: 'in_analysis' }

        it { is_expected.to allow_value(nil).for(:video_url) }
      end
    end

    context 'when goal is minimum' do
      context 'and project is online' do
        let(:project) { build :project, goal: 5000, state: 'online' }

        it { is_expected.not_to allow_value(nil).for(:video_url) }
      end

      context 'and project is in analysis' do
        let(:project) { build :project, goal: 5000, state: 'in_analysis' }

        it { is_expected.not_to allow_value(nil).for(:video_url) }
      end
    end
  end

  describe '.order_by' do
    subject { Project.last.name }

    before do
      create(:project, name: 'lorem')
      #testing for sql injection
      Project.order_by("goal asc;update projects set name ='test';select * from projects ").first #use first so the sql is actually executed
    end

    it { is_expected.to eq('lorem') }
  end

  describe '.between_created_at' do
    let(:start_at) { '17/01/2013' }
    let(:ends_at)  { '20/01/2013' }
    subject        { Project.between_created_at(start_at, ends_at).map(&:name) }

    context "when there are projects in the between range" do
      before do
        create(:project, name: 'project_1', created_at: '19/01/2013')
        create(:project, name: 'project_2', created_at: '18/01/2013')
      end

      it { is_expected.to contain_exactly('project_1', 'project_2') }
    end

    context "when there are no projects in the between range" do
      before do
        create(:project, created_at: '23/01/2013')
        create(:project, created_at: '26/01/2013')
      end

      it { is_expected.to be_empty }
    end
  end

  describe '.between_expires_at' do
    let(:start_at) { '17/01/2013' }
    let(:ends_at)  { '22/01/2013' }
    subject        { Project.between_expires_at(start_at, ends_at).map(&:name) }

    context "when there are projects in the between range" do
      before do
        create(:project, name: 'project_17_01', online_date: '17/01/2013', online_days: 1)
        create(:project, name: 'project_21_01', online_date: '21/01/2013', online_days: 1)
      end

      it { is_expected.to contain_exactly('project_17_01', 'project_21_01') }
    end

    context "when there are no project in the between range" do
      before { create(:project, online_date: '23/01/2013', online_days: 1) }

      it { is_expected.to be_empty }
    end
  end

  describe "send_verify_moip_account_notification" do
    before do
      @p = create(:project, state: 'online', online_date: DateTime.now, online_days: 3)
      create(:project, state: 'draft')
    end

    it "should create notification for all projects that is expiring" do
      expect(ProjectNotification).to receive(:notify_once).
        with(:verify_moip_account, @p.user, @p, {from_email: CatarseSettings[:email_payments]})
      Project.send_verify_moip_account_notification
    end
  end

  describe '#reached_goal?' do
    let(:project) { create(:project, goal: 3000) }
    subject { project.reached_goal? }

    context 'when sum of all contributions hit the goal' do
      before do
        create(:contribution, value: 4000, project: project)
      end
      xit { is_expected.to eq(true) }
    end

    context "when sum of all contributions don't hit the goal" do
      it { is_expected.to eq(false) }
    end
  end

  describe '#in_time_to_wait?' do
    let(:contribution) { create(:contribution, state: 'waiting_confirmation') }
    subject { contribution.project.in_time_to_wait? }

    context 'when project expiration is in time to wait' do
      it { is_expected.to eq(true) }
    end

    context 'when project expiration time is not more on time to wait' do
      let(:contribution) { create(:contribution, created_at: 1.week.ago) }
      it {is_expected.to eq(false)}
    end
  end

  describe "#pledged_and_waiting" do
    subject{ project.pledged_and_waiting }
    before do
      @confirmed = create(:contribution, value: 10, state: 'confirmed', project: project)
      @waiting = create(:contribution, value: 10, state: 'waiting_confirmation', project: project)
      create(:contribution, value: 100, state: 'refunded', project: project)
      create(:contribution, value: 1000, state: 'pending', project: project)
    end
    it{ is_expected.to eq(@confirmed.value + @waiting.value) }
  end

  describe "#pledged" do
    subject(:pledged_value){ project.pledged }

    context "when project_total is nil" do
      before do
        allow(project).to receive(:project_total).and_return(nil)
      end
      it{ is_expected.to eq(0) }
    end

    context "when project_total exists" do
      context "when two contributions with state confirmed and/or requested_refund exists" do
        before do
          create(:contribution, :confirmed, project_value: 100, project: project)
          create(:contribution, :requested_refund, project_value: 75, project: project)
        end

        it 'expect sum of contributions' do
          expect(pledged_value).to eq(175.0)
        end
      end

      context "when contribution with pending state exists" do
        before do
          create(:contribution, :pending, project_value: 100, project: project)
        end

        it 'is not added' do
          expect(pledged_value).to eq(0)
        end
      end

      context "when contribution with waiting_confirmation state exists" do
        before do
          create(:contribution, project_value: 100, state: 'waiting_confirmation', project: project)
        end

        it 'is not added' do
          expect(pledged_value).to eq(0)
        end
      end

      context "when contribution with canceled state exists" do
        before do
          create(:contribution, :canceled, project_value: 100, project: project)
        end

        it 'is not added' do
          expect(pledged_value).to eq(0)
        end
      end

      context "when contribution with refunded state exists" do
        before do
          create(:contribution, :refunded, project_value: 100, project: project)
        end

        it 'is not added' do
          expect(pledged_value).to eq(0)
        end
      end

      context "when contribution with refunded_and_canceled state exists" do
        before do
          create(:contribution, :refunded_and_canceled, project_value: 100, project: project)
        end

        it 'is not added' do
          expect(pledged_value).to eq(0)
        end
      end

      context "when contribution with deleted state exists" do
        before do
          create(:contribution, :deleted, project_value: 100, project: project)
        end

        it 'is not added' do
          expect(pledged_value).to eq(0)
        end
      end

      context "when contribution with invalid_payment state exists" do
        before do
          create(:contribution, :invalid_payment, project_value: 100, project: project)
        end

        it 'is not added' do
          expect(pledged_value).to eq(0)
        end
      end

      context "when there are contributions with requested_refund and confirmed states and contributions with an invalid state" do
        before do
          ['pending', 'waiting_confirmation', 'canceled',
           'refunded', 'refunded_and_canceled', 'deleted',
           'invalid_payment'].each do |state|
             create(:contribution, state: state, project_value: 100, project: project)
           end
          create(:contribution, :requested_refund, project_value: 171, project: project)
          create(:contribution, :confirmed, project_value: 15, project: project)
        end

        it 'expect sum only of the contributions with requested_refund and confirmed states' do
          expect(pledged_value).to eq(186.0)
        end
      end
    end
  end

  describe "#total_payment_service_fee" do
    subject { project.total_payment_service_fee }

    context "when project_total is nil" do
      before { allow(project).to receive(:project_total).and_return(nil) }
      it { is_expected.to eq(0) }
    end

    context "when project_total exists" do
      before do
        project_total = double()
        allow(project_total).to receive(:total_payment_service_fee).and_return(4.0)
        allow(project).to receive(:project_total).and_return(project_total)
      end

      it { is_expected.to eq(4.0) }
    end
  end

  describe "#total_contributions" do
    subject{ project.total_contributions }
    context "when project_total is nil" do
      before do
        allow(project).to receive(:project_total).and_return(nil)
      end
      it{ is_expected.to eq(0) }
    end
    context "when project_total exists" do
      before do
        project_total = double()
        allow(project_total).to receive(:total_contributions).and_return(1)
        allow(project).to receive(:project_total).and_return(project_total)
      end
      it{ is_expected.to eq(1) }
    end
  end

  describe "#expired?" do
    subject{ project.expired? }

    context "when online_date is nil" do
      let(:project){ Project.new online_date: nil, online_days: 0 }
      it{ is_expected.to eq(nil) }
    end

    context "when expires_at is in the future" do
      let(:project){ Project.new online_date: 2.days.from_now, online_days: 0 }
      it{ is_expected.to eq(nil) }
    end

    context "when expires_at is in the past" do
      let(:project){ build(:project, online_date: 3.days.ago, online_days: 1) }
      before{project.save!}
      it{ is_expected.to eq(true) }
    end
  end

  describe "#expires_at" do
    subject{ project.expires_at }
    context "when we do not have an online_date" do
      let(:project){ build(:project, online_date: nil, online_days: 1) }
      it{ is_expected.to be_nil }
    end
    context "when we have an online_date" do
      let(:project){ create(:project, online_date: Time.now, online_days: 1)}
      before{project.save!}
      it{ is_expected.to eq(Time.zone.tomorrow.end_of_day.to_s(:db)) }
    end
  end

  describe '#selected_rewards' do
    let(:project)   { create(:project) }
    let(:reward_01) { create(:reward, description: 'reward_1', project: project) }
    let(:reward_02) { create(:reward, description: 'reward_2', project: project) }
    let(:reward_03) { create(:reward, description: 'reward_3', project: project) }
    subject         { project.selected_rewards.map(&:description) }

    context "when there are confirmed contributions" do
      before do
        create(:contribution, :confirmed, project: project, reward: reward_01)
        create(:contribution, :confirmed, project: project, reward: reward_03)
      end

      it { is_expected.to contain_exactly('reward_1', 'reward_3') }
    end

    context "when there are not confirmed contributions" do
      before do
        create(:contribution, :pending, project: project, reward: reward_01)
        create(:contribution, :waiting_confirmation, project: project, reward: reward_03)
        create(:contribution, :canceled, project: project, reward: reward_03)
        create(:contribution, :refunded, project: project, reward: reward_03)
      end

      it { is_expected.to be_empty }
    end
  end

  describe '#accept_contributions?' do
    context 'when project is online' do
      context 'and is not expired' do
        context 'and is available for contribution' do
          let(:project) { create(:project, :online, :not_expired, available_for_contribution: true) }

          it { expect(project).to be_accept_contributions }
        end

        context 'and not available for contribution' do
          let(:project) { create(:project, :online, :not_expired, available_for_contribution: false) }

          it { expect(project).not_to be_accept_contributions }
        end
      end

      context 'and is expired' do
        let(:project) { create(:project, :online, :expired, available_for_contribution: true) }

        it { expect(project).not_to be_accept_contributions }
      end
    end

    context 'when project is not online' do
      let(:project) { create(:project, state: 'failed') }

      it { expect(project).not_to be_accept_contributions }
    end
  end

  describe "#last_channel" do
    let(:channel){ create(:channel) }
    let(:project){ create(:project, channels: [ create(:channel), channel ]) }
    subject{ project.last_channel }
    xit{ is_expected.to eq(channel) }
  end

  describe '#pending_contributions_reached_the_goal?' do
    let(:project) { create(:project, goal: 200) }

    subject { project.pending_contributions_reached_the_goal? }

    context 'when reached the goal with pending contributions' do
      before { 2.times { create(:contribution, project: project, value: 120, state: 'waiting_confirmation') } }

      xit { is_expected.to eq(true) }
    end

    context 'when dont reached the goal with pending contributions' do
      before { 2.times { create(:contribution, project: project, value: 30, state: 'waiting_confirmation') } }

      it { is_expected.to eq(false) }
    end
  end

  describe "#new_draft_recipient" do
    subject { project.new_draft_recipient }
    before do
      CatarseSettings[:email_projects] = 'admin_projects@foor.bar'
      @user = create(:user, email: CatarseSettings[:email_projects])
    end
    it{ is_expected.to eq(@user) }
  end

  describe "#notification_type" do
    subject { project.notification_type(:foo) }
    context "when project does not belong to any channel" do
      it { is_expected.to eq(:foo) }
    end

    context "when project does belong to a channel" do
      let(:project) { channel_project }
      xit{ is_expected.to eq(:foo_channel) }
    end
  end

  describe ".enabled_to_use_pagarme" do
    subject { Project.enabled_to_use_pagarme.map(&:name) }
    before  { CatarseSettings[:projects_enabled_to_use_pagarme] = 'a, c' }

    context "when there are projects enabled to use pagarme" do
      before do
        create(:project, name: 'permalink_a', permalink: 'a')
        create(:project, name: 'permalink_c', permalink: 'c')
      end

      it { is_expected.to contain_exactly('permalink_a', 'permalink_c') }
    end

    context "when there are not projects enabled to use pagarme" do
      before do
        create(:project, name: 'permalink_k', permalink: 'k')
        create(:project, name: 'permalink_b', permalink: 'b')
      end

      it { is_expected.to be_empty }
    end
  end

  describe "#using_pagarme?" do
    let(:project) { create(:project, permalink: 'foo') }

    subject { project.using_pagarme? }

    context "when project is using pagarme" do
      before do
        CatarseSettings[:projects_enabled_to_use_pagarme] = 'foo'
      end

      it { is_expected.to be_truthy }
    end

    context "when project is not using pagarme" do
      before do
        CatarseSettings[:projects_enabled_to_use_pagarme] = nil
      end

      it { is_expected.to be_falsey }
    end
  end

  describe '#recurring?' do
    subject { project.recurring? }

    context 'when a project belongs to a recurring channel' do
      let(:channel) { create :channel, recurring: true }
      let(:project) { create :project, channels: [channel] }

      it { is_expected.to be_truthy }
    end

    context 'when a project does not belong to a recurring channel' do
      let(:project) { create :project }

      it { is_expected.to be_falsey }
    end
  end

  describe '#color' do
    subject { project.color }

    before { CatarseSettings[:default_color] = '#ff8a41' }

    context 'when a project belongs to a recurring channel' do
      let(:default_color) { CatarseSettings[:default_color] }
      let(:channel) { create :channel, recurring: true }
      let(:project) { create :project, channels: [channel] }

      it 'returns the default color' do
        expect(subject).to eq default_color
      end
    end

    context 'when a project is not related to a recurring channel' do
      let(:category) { create :category }
      let(:project) { create :project, category: category }

      it 'returns the category color' do
        expect(subject).to eq category.color
      end
    end
  end

  describe '#project_images_limit?' do
    let(:project) { create :project }

    subject { project.reload.project_images_limit? }

    before { CatarseSettings[:project_images_limit] = '8' }

    context 'when project has no images' do
      it { is_expected.to be_falsey }
    end

    context 'when project has less than eight images' do
      let!(:project_images) { create_list :project_image, 5, project: project }

      it { is_expected.to be_falsey }
    end

    context 'when project has reached the images limit' do
      let!(:project_images) { create_list :project_image, 8, project: project }

      it { is_expected.to be_truthy }
    end
  end

  describe '#project_partners_limit?' do
    let(:project) { create :project }

    subject { project.reload.project_partners_limit? }

    before { CatarseSettings[:project_partners_limit] = '3' }

    context 'when project has no partners' do
      it { is_expected.to be_falsey }
    end

    context 'when project has less than three partners' do
      let!(:project_partner) do
        create_list :project_partner, 1, project: project
      end

      it { is_expected.to be_falsey }
    end

    context 'when project has reached the partners limit' do
      let!(:project_partner) do
        create_list :project_partner, 3, project: project
      end

      it { is_expected.to be_truthy }
    end
  end

  context 'when a project belongs to a recurring channel' do
    let(:recurring_channel) { create :channel, recurring: true }
    subject {
      build :project,
        channels: [recurring_channel],
        category: nil,
        online_days: nil
    }

    describe 'validations' do
      it { is_expected.not_to validate_presence_of :category }
    end
  end

  describe 'pg_search scope associating other scopes' do
    context 'when associated scope joins one table used in associated_against of pg_search' do
      context 'when there are projects having user that matches the user name searched in user_name_contains scope' do
        before do
          john = create(:user, address_city: 'Orange town', name: 'John')
          steve = create(:user, name: 'Steve')
          create(:project, user: steve, name: 'Project about fruits')
          create(:project, user: steve, name: 'Apples', headline: 'Project about Apples')
          create(:project, user: steve, name: 'Oranges', about: 'Project about Oranges')
          create(:project, user: john, name: 'Project about Lemons')
          create(:project, user: user, name: 'Project about Vegetables')
          create_list :project, 4
        end

        it 'returns projects with name matching the pg_search term' do
          projects = Project.pg_search('about fruits').user_name_contains('Steve')
          expect(projects.map(&:name)).to match(['Project about fruits'])
        end

        it 'returns projects with headline matching the pg_search term' do
          projects = Project.pg_search('about apples').user_name_contains('Steve')
          expect(projects.map(&:name)).to match(['Apples'])
        end

        it 'returns projects with about attribute matching the pg_search term' do
          projects = Project.pg_search('about oranges').user_name_contains('Steve')
          expect(projects.map(&:name)).to match(['Oranges'])
        end

        it 'returns projects having user\'s address_city attribute matching the pg_search term' do
          projects = Project.pg_search('orange town').user_name_contains('John')
          expect(projects.map(&:name)).to match(['Project about Lemons'])
        end

        it 'returns projects having name, headline and/or about attributes matching the pg_search term' do
          projects = Project.pg_search('about').user_name_contains('Steve')
          expect(projects.map(&:name)).to match_array(['Project about fruits', 'Apples', 'Oranges'])
        end

        it 'ommits projects which do not have name, headline and/or about attributes matching the pg_search term' do
          projects = Project.pg_search('about fruits').user_name_contains('Steve')
          expect(projects.map(&:name)).not_to match(['Project about Vegetables'])
        end
      end

      context 'when there are not projects with user that matches the user name searched in user_name_contains scope' do
        before do
          create(:user_with_projects, projects_count: 1, name: 'John')
        end

        it 'does not return projects' do
          projects = Project.pg_search('john').user_name_contains('Steve')
          expect(projects.count(:all)).to eq(0)
        end
      end
    end
  end
end

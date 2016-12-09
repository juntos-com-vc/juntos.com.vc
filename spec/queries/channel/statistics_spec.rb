require 'rails_helper'

RSpec.describe ChannelStatisticsQuery do
  let (:successful_project) { create(:project) }
  let (:online_project) { create(:project, :online) }
  let (:waiting_funds_project) { create(:project, :online) }
  let (:failed_project) { create(:project) }
  let (:channel) { create(:channel, projects: [successful_project, online_project, waiting_funds_project, failed_project]) }
  let (:channel_statistics) { ChannelStatisticsQuery.new(channel) }

  before do
    create_list(:contribution, 2, project: successful_project, project_value: 10)
    create_list(:contribution, 2, project: online_project, project_value: 15)
    create_list(:contribution, 2, project: waiting_funds_project, project_value: 7)
    create_list(:contribution, 2, project: failed_project, project_value: 35)
    create(:contribution, :pending, project_value: 200, project: online_project)
    create(:contribution, :waiting_confirmation, project_value: 270, project: online_project)

    failed_project.update_attributes(state: 'failed')
    waiting_funds_project.update_attributes(state: 'waiting_funds')
    successful_project.update_attributes(state: 'successful')
  end

  describe '.total_projects' do
    it 'counts how many successful projects has inside a channel' do
      expect(channel_statistics.successful_projects_count).to eq(1)
    end
  end

  describe '.total_contributions' do
    it 'counts how many confirmed, refunded, requested_refund contributions a channel has' do
      expect(channel_statistics.contributions_count).to eq(6)
    end
  end

  describe '.total_pledged' do
    it 'sum pledged from all successful, online and waiting_funds projects inside a channel' do
      expect(channel_statistics.total_pledged).to eq(64)
    end
  end
end

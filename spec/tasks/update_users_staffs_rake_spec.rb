require 'rails_helper'
require 'rake'

RSpec.describe 'Users' do
  before(:all) do
    Rake.application.rake_require "tasks/update_users_staffs"
    Rake::Task.define_task(:environment)
  end

  describe 'update_users_staffs' do
    let(:run_rake_task) do
      Rake::Task['users:update_users_staffs'].reenable
      Rake.application.invoke_task 'users:update_users_staffs'
    end

    it { expect {run_rake_task}.to output(/Update users staffs/).to_stdout }
  end
end

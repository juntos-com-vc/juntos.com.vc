require 'rails_helper'
require 'rake'

RSpec.describe 'Users' do
  before(:all) do
    Rake.application.rake_require "tasks/fix_user_documents_url"
    Rake::Task.define_task(:environment)
  end

  describe 'fix_user_documents_url' do
    let(:run_rake_task) do
      Rake::Task['users:fix_user_documents_url'].reenable
      Rake.application.invoke_task 'users:fix_user_documents_url'
    end

    let(:service) { double('fix order user service') }

    it { expect {run_rake_task}.to output(/Fixing users documents/).to_stdout } 
  end
end

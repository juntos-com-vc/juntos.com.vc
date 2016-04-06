namespace :users do
  desc 'Fix users documents urls'
  task 'fix_user_documents_url' => :environment do
    puts "--- Fixing users documents url in order to remove uploader"
    User::FixUsersDocumentsURLService.process
  end
end

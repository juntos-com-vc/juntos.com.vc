namespace :users do
  desc 'Update users staffs'
  task 'update_users_staffs' => :environment do
    puts '--- Update users staffs in order to allow users to belong to more than one team'
    User::UpdateUsersStaffsService.process
  end
end

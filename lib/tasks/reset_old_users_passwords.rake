namespace :migration do
  desc "Updates uncrypted passwords from migrated users"
  task :update_passwords => :environment do
    users = User.where.not(uuid: nil)
    puts "#{users.count} to have their password updated"
    User.transaction do
      users.each do |user|
        puts "Updating #{user.id} - #{user.full_name} password"
        user.password = user.password_confirmation = user.uncrypted_password
        user.save(validate: false)
      end
      users.update_all(uncrypted_password: nil)
    end
  end
end

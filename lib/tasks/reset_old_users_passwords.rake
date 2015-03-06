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

  desc "Imports the project cover images"
  task :import_project_images => :environment do
    projects = Project.where.not(uuid: nil)
    puts "#{projects.count} to be imported"
    projects.each do |project|
      sql = "SELECT t1.arquivo
              FROM
                (SELECT arquivo, grupo, id
                FROM old_db.juntoscomvc_arquivo
                UNION ALL
                SELECT arquivo, grupo, id
                FROM old_db.garupa_arquivo) as t1
                WHERE grupo = 'capa'
                  AND id = '#{project.uuid}'"
      image_link = ActiveRecord::Base.connection.execute(sql).values.first.try(:first)
      if image_link.present?
        puts project.permalink, image_link, "\n"
        project.remote_uploaded_image_url = "http://juntos.com.vc/dados/projeto/#{image_link}"
        project.save
      end
    end
  end

  desc "Imports the profile images"
  task :import_user_images => :environment do
    users = User.where.not(uuid: nil)
    puts "#{users.count} to be imported"
    users.each do |user|
      sql = "SELECT t1.arquivo
              FROM
                (SELECT arquivo, grupo, id
                FROM old_db.juntoscomvc_arquivo
                UNION ALL
                SELECT arquivo, grupo, id
                FROM old_db.garupa_arquivo) as t1
                WHERE grupo = 'avatar'
                  AND id = '#{user.uuid}'"
      image_link = ActiveRecord::Base.connection.execute(sql).values.first.try(:first)
      if image_link.present? && image_link != 'juntos-com-vc-avatar.png'
        puts user.name, image_link, "\n"
        user.remote_uploaded_image_url = "http://juntos.com.vc/dados/cliente/#{image_link}"
        user.save
      end
    end
  end
end

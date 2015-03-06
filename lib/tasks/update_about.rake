namespace :migration do
  desc "Updates the projects' description and about"
  task :update_about => :environment do
    projects = Project.all
    puts "#{projects.count} to have their about updated"
    Project.transaction do
      projects.each do |project|
        puts "Updating #{project.id} - #{project.name} about"
        project.about = ActionView::Base.full_sanitizer.sanitize(project.about, tags: [])
        project.about = Nokogiri::HTML.parse(project.about).text
        project.about = 'about' if project.about.empty?

        project.headline = ActionView::Base.full_sanitizer.sanitize(project.headline, tags: [])
        project.headline = Nokogiri::HTML.parse(project.headline).text
        project.headline = 'headline' if project.headline.empty?

        project.save
      end
    end
  end
end

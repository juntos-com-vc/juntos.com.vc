namespace :page do
  desc 'Add pt to language in each page'
  task update_locale: :environment do
    Page.update_all locale: :pt
  end
  
  desc 'Duplicate all pages and add en to language in the new ones'
  task duplicate: :environment do
    pages = Page.all.map(&:dup)
    pages.each do |page|
      page.locale = :en
      page.save
    end
  end
end

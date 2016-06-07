require 'rails_helper'
require 'rake'

RSpec.describe 'UpdatePagesLocale', type: :rake do
  Rails.application.load_tasks  

  describe 'page:update_locale' do
    it 'should update all pages with pt in language' do
      page = create(:page, name: Page.names.keys.first)

      Rake::Task['page:update_locale'].invoke

      expect(page.reload.locale).to eq 'pt'
    end
  end
  
  describe 'page:duplicate' do
    it 'should duplicate all pages and add en to language in the new ones' do
      create(:page, name: Page.names.keys.first, locale: :pt)

      Rake::Task['page:duplicate'].invoke

      expect(Page.count).to eq 2
      pages = Page.all

      expect(pages.first.locale).to eq 'pt'
      expect(pages.second.locale).to eq 'en'
    end
  end
end

require 'rails_helper'

RSpec.describe ProjectsHelper, type: :helper do

  describe '#format_url_to_remove_secure' do

    let(:url) { 'https://secure.lvh.me:3000/pt/projetor' }
    
    context 'when project have channel' do
      let(:channel) { create(:channel) }
      let(:project) { create(:project, channels: [channel]) }
    
      it 'should replace secure for channel name' do
        puts format_url_to_remove_secure(url, project)
        expect(format_url_to_remove_secure(url, project)).to include channel.permalink
        expect(format_url_to_remove_secure(url, project)).not_to include 'secure'
        expect(format_url_to_remove_secure(url, project)).not_to include 'https'
      end
    end
    
    context 'when project not have channel' do
      let(:project) { create(:project) }
    
      it 'should replace secure for channel name' do
        puts format_url_to_remove_secure(url, project)
        expect(format_url_to_remove_secure(url, project)).not_to include 'secure'
        expect(format_url_to_remove_secure(url, project)).not_to include 'https'
      end
    end

  end
end

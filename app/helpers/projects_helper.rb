module ProjectsHelper
  
  def format_url_to_remove_secure(url, project)
    url.gsub('https', 'http').gsub('secure.', format_channel(project.channels)) 
  end
 
  def format_channel(channel)
    (channel.first) ? channel.first.permalink + '.' : ''
  end
end

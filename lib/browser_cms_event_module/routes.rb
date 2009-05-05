module Cms::Routes
  def routes_for_browser_cms_event_module
    namespace(:cms) do |cms|
      cms.content_blocks :events
    end  
  end
end

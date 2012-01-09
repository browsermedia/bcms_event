module Cms::Routes
  def routes_for_bcms_event
    namespace(:cms) do
      content_blocks :events
    end  
  end
end

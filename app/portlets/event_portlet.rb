class EventPortlet < Cms::Portlet
    
  enable_template_editor true
  
  def render
    # @event should already be set by the page route
    if !@event && params[:event_id]
      @event = BcmsEvent::Event.published.find(params[:event_id])
    end
  end
    
end
class EventPortlet < Portlet
    
  def render
    # @event should already be set by the page route
    if !@event && params[:event_id]
      @event = Event.published.find(params[:event_id])
    end
  end
    
end
class EventsPortlet < Portlet
    
  def render
    @events = Event.published.all
  end
    
end
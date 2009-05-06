class EventsPortlet < Portlet
    
  def render
    if self.category_id.blank?
      @events = Event.all
    else
      @events = Event.all(:conditions => {:category_id => self.category_id})
    end
  end
    
end
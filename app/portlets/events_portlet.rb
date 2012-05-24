class EventsPortlet < Cms::Portlet
    
  enable_template_editor true
    
  def render
    if self.category_id.blank?
      @events = BcmsEvent::Event.published.all
    else
      @events = BcmsEvent::Event.published.all(:conditions => {:category_id => self.category_id})
    end
  end
    
end
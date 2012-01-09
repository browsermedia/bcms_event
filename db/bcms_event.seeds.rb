# Load the seed data specifically for the Event Module
# Add the following line to your seeds.rb to make db:seed run this file:
#   load File.expand_path('../bcms_event.seeds.rb', __FILE__)
unless CategoryType.named('Event').exists?
  CategoryType.create!(:name => "Event")
end

ContentType.create!(:name => "Event", :group_name => "Event")

event_page = Page.create!(
  :name => "Event", 
  :path => "/event", 
  :section => Section.root.first,
  :template_file_name => "default.html.erb")
  
EventPortlet.create!(
  :name => "Event Details",
  :template => EventPortlet.default_template,
  :connect_to_page_id => event_page.id,
  :connect_to_container => "main",
  :publish_on_save => true)
  
events_page = Page.create!(
    :name => "Events", 
    :path => "/events", 
    :section => Section.root.first,
    :template_file_name => "default.html.erb")
    
EventsPortlet.create!(
  :name => "Event List",
  :template => EventsPortlet.default_template,
  :connect_to_page_id => events_page.id,
  :connect_to_container => "main",
  :publish_on_save => true)      
  
route = event_page.page_routes.build(
  :name => "Event",
  :pattern => "/events/:year/:month/:day/:slug",
  :code => "@event = Event.published.starts_on(params).with_slug(params[:slug]).first")
route.add_condition(:method, "get")
route.add_requirement(:year, '\d{4,}')
route.add_requirement(:month, '\d{2,}')
route.add_requirement(:day, '\d{2,}')
route.save!
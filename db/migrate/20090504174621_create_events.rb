class CreateEvents < ActiveRecord::Migration
  def self.up
    create_versioned_table :events do |t|
      t.string :name 
      t.string :slug
      t.date :starts_on 
      t.date :ends_on 
      t.string :location 
      t.string :contact_email 
      t.text :description 
      t.string :more_info_url 
      t.string :registration_url 
      t.belongs_to :category 
      t.text :body, :size => (64.kilobytes + 1) 
    end
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
      
    EventsPortlet.create!(
      :name => "Event List",
      :template => EventsPortlet.default_template,
      :connect_to_page_id => event_page.id,
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
    
  end

  def self.down
    ContentType.delete_all(['name = ?', 'Event'])
    CategoryType.all(:conditions => ['name = ?', 'Event']).each(&:destroy)
    drop_table :event_versions
    drop_table :events
  end
end

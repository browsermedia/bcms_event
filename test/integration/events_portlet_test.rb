require 'test_helper'

class EventsPortletTest < ActionController::IntegrationTest
  
  def setup
    create_baseline_data!
    create_sample_data!
    @events_portlet = EventsPortlet.create!(:name => "Events Portlet",
      :template => EventsPortlet.default_template,
      :connect_to_page_id => @events_page.id,
      :connect_to_container => "main",
      :publish_on_save => true)
      
    @show_event_portlet = Factory(:event_portlet, :path=>"/event")
  end
  
  def test_show_post
    get "/events"

    assert_response :success
    assert_select "title", "Events"
    
    assert_select ".event" do
      assert_select ".event_starts_on", "January 19, 2009"
      assert_select "a b", "Martin Luther King Day"
    end
    
    assert_select ".event a b", {:text => "Unpublished", :count => 0}
    
  end
  
  test "setup" do
    p = Portlet.find_by_name("Show Event")
    assert_not_nil p
    
  end
  
  test "The 'event' page should be blank if no event parameter is supplied" do
    get "/event"
    
    assert_response :success
    assert_doesnt_have_content "ERROR: undefined method `name' for nil:NilClass"
    assert_has_content "Missing required parameter"
  end
  
  private 
  
  def assert_has_content(value)
    assert_match /#{value}/, @response.body
  end
  
  def assert_doesnt_have_content(value)
    assert_no_match /#{value}/, @response.body    
  end
  
  # Fake API for Factory Girl
  def Factory(name, options={})    
    defaults = {:name=>"Show Event",
                :connect_to_container => "main",
                :template => EventPortlet.default_template,
                :path => "/event",
                :publish_on_save => true
               }
    defaults.merge!(options)
    path = defaults.delete(:path)
    defaults[:connect_to_page_id] = Page.with_path(path).first.id 
    EventPortlet.create!(defaults)
  end
end
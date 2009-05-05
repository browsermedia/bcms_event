require File.dirname(__FILE__) + '/../test_helper'

class EventsPortletTest < ActionController::TestCase
  tests Cms::ContentController
  
  def setup
    create_baseline_data!
    create_sample_data!
    @events_portlet = EventsPortlet.create!(:name => "Events Portlet",
      :template => EventsPortlet.default_template,
      :connect_to_page_id => @events_page.id,
      :connect_to_container => "main",
      :publish_on_save => true)
  end
  
  def test_show_post
    get :show, :path => ["events"]
    #log @response.body
    assert_response :success
    assert_select "title", "Events"
    
    assert_select ".event" do
      assert_select ".event_starts_on", "January 19, 2009"
      assert_select "a b", "Martin Luther King Day"
    end
    
    assert_select ".event a b", {:text => "Unpublished", :count => 0}
    
  end
  
end
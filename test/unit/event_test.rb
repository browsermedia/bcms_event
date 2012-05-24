require 'test_helper'

module BcmsEvent
  class EventTest < ActiveSupport::TestCase
  
    test "create with minimum defaults" do
      assert Event.create!(:name=>"Hello", :starts_on=>Date.today)
    end
  
    test "Starts On" do
      last_weeks_event = Factory(:event, :starts_on=>1.week.ago)
      todays_event = Factory(:event, :starts_on=>Date.today)
    
      assert_equal [todays_event], Event.starts_on(Date.today)
    end
  
    test "with_slug" do
      expected_event = Factory(:event, :name=>"Find")
      unexpected_event = Factory(:event, :name=>"Dont Find")
    
      assert_equal [expected_event], Event.with_slug("find")
    
    end
  
    private
  
    # Faking a Factory girl API until Rails 3.1 upgrade because I don't want to install it.
    def Factory(name, options={})
      defaults = {:name=>"Hello", :starts_on=>Date.today}
      Event.create!(defaults.merge(options))
    end  
  end
end
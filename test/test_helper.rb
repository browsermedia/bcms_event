ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

class ActiveSupport::TestCase
  require File.dirname(__FILE__) + '/test_logging'
  include TestLogging
  include SampleData
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  #
  # The only drawback to using transactional fixtures is when you actually 
  # need to test transactions.  Since your test is bracketed by a transaction,
  # any transactions started in your code will be automatically rolled back.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def create_baseline_data!
    @section = Section.create!(:name => "My Site", :path => "/")
    Group.create!(:name => "Guest", :code => "guest", :sections => [@section])
    @page_template = PageTemplate.create!(:name => "test", :format => "html", :handler => "erb", :body => %q{<html>
      <head>
        <title>
          <%= page_title %>
        </title>
        <%= yield :html_head %>
      </head>
      <body>
        <%= cms_toolbar %>
        <%= container :main %>
      </body>
    </html>})

    @events_page = Page.create!(:name => "Events", :section => @section, :path => "/events", :template_file_name => "test.html.erb")
    @event_page = Page.create!(:name => "Event", :section => @section, :path => "/event", :template_file_name => "test.html.erb")

    @event_route = @event_page.page_routes.build(
      :name => "Event",
      :pattern => "/events/:year/:month/:day/:slug",
      :code => "@event = Event.published.starts_on(params).with_slug(params[:slug]).first")
    @event_route.add_condition(:method, "get")
    @event_route.add_requirement(:year, '\d{4,}')
    @event_route.add_requirement(:month, '\d{2,}')
    @event_route.add_requirement(:day, '\d{2,}')
    @event_route.save!    

    @events_page.publish!
    @event_page.publish!
  end  
end

module Cms
  module SampleData
  
    def create_baseline_data!
      @section = Section.create!(:name => "My Site", :path => "/")
      g = Group.create!(:name => "Guest", :code => "guest")
      g.sections = [@section]
      g.save!
      
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
  
    def create_sample_data!
      category_type = CategoryType.find_or_create_by_name("Event")
      holidays = category_type.categories.find_or_create_by_name("Holidays")
      ravens = category_type.categories.find_or_create_by_name("Ravens")
    
      [ # Holidays
        ["January 1, 2009", "New Year's Day", "Jan. 1 every year"],
        ["January 19, 2009", "Martin Luther King Day", "3rd monday in Jan"],
        ["January 20, 2009", "Inauguration Day", "every 4th year"],
        ["February 16, 2009", "Presidents Day", "3rd monday in Feb\n\nPresidents Day is also Washington's Birthday"],
        ["May 25, 2009", "Memorial Day", "last monday in May"],
        ["July 4, 2009", "Independence Day", "July 4 every year"],
        ["September 7, 2009", "Labor Day", "1st monday in Sept"],
        ["October 12, 2009", "Columbus Day", "2nd monday in Oct"],
        ["November 11, 2009", "Veterans' Day", "Nov. 11 every year"],
        ["November 26, 2009", "Thanksgiving Day", "4th thursday in Nov"],
        ["December 25, 2009", "Christmas Day", "Dec. 25 every year"]
      ].each do |e|
        BcmsEvent::Event.create!(
          :name => e[1],
          :category => holidays,
          :description => e[2],
          :starts_on => Date.parse(e[0]),
          :publish_on_save => true)
      end
    
      [ #Ravens Games
        ["2009-09-13", "Baltimore vs. Kansas City, 1 p.m."  ],
        ["2009-09-20", "Baltimore at San Diego, 4:15 p.m."  ],
        ["2009-09-27", "Baltimore vs. Cleveland, 1 p.m."    ],
        ["2009-10-04", "Baltimore at New England, 1 p.m."   ],
        ["2009-10-11", "Baltimore vs. Cincinnati, 1 p.m."   ],
        ["2009-10-18", "Baltimore at Minnesota, 1 p.m."     ],
        ["2009-11-01", "Baltimore vs. Denver, 1 p.m."       ],
        ["2009-11-08", "Baltimore at Cincinnati, 1 p.m."    ],
        ["2009-11-16", "Baltimore at Cleveland, 8:30 p.m."  ],
        ["2009-11-22", "Baltimore vs. Indianapolis, 1 p.m." ],
        ["2009-11-29", "Baltimore vs. Pittsburgh, 8:20 p.m."],
        ["2009-12-07", "Baltimore at Green Bay, 8:30 p.m."  ],
        ["2009-12-13", "Baltimore vs. Detroit, 1 p.m."      ],
        ["2009-12-20", "Baltimore vs. Chicago, 1 p.m."      ],
        ["2009-12-27", "Baltimore at Pittsburgh, 1 p.m."    ],
        ["2010-01-03", "Baltimore at Oakland, 4:15 p.m."    ]
      ].each do |e|
        BcmsEvent::Event.create!(
          :name => e[1],
          :category => ravens,
          :starts_on => Date.parse(e[0]),
          :publish_on_save => true)
      end
    
    
      BcmsEvent::Event.create!(
        :name => "Unpublished",
        :category => @general,
        :description => "This event is not published",
        :starts_on => Date.parse("2009-05-05"),
        :publish_on_save => false)
    end
    extend self
  end
end
ActiveSupport::TestCase.send(:include, Cms::SampleData)
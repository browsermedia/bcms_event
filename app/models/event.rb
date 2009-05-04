class Event < ActiveRecord::Base
  acts_as_content_block :taggable => true
  belongs_to_category
  

end

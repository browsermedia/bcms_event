module BcmsEvent
class Event < ActiveRecord::Base
  acts_as_content_block :taggable => true
  belongs_to_category
  
  before_validation :set_slug
  validates_presence_of :name, :slug, :starts_on
  
  attr_accessible :category, :name, :description, :starts_on
  
  scope :starts_on, lambda {|date|
    d = if date.kind_of?(Hash)
      Date.new(date[:year].to_i, date[:month].to_i, date[:day].to_i)
    else
      date
    end
    
    {:conditions => ["starts_on = ?", d]}
  }
      
  scope :with_slug, lambda{|slug| {:conditions => ["slug = ?",slug]}}  

  def self.default_order
    "starts_on desc"
  end
  
  def self.columns_for_index
    [ {:label => "Name", :method => :name, :order => "name" },
      {:label => "Starts On", :method => :starts_on_label, :order => "starts_on" } ]
  end  
  
  def starts_on_label
    starts_on ? starts_on.to_s(:long) : nil
  end
  
  def set_slug
    self.slug = name.to_slug
  end
  
  def route_params
    {:year => year, :month => month, :day => day, :slug => slug}
  end  
  
  def year
    starts_on.strftime("%Y")
  end
  
  def month
    starts_on.strftime("%m")
  end
  
  def day
    starts_on.strftime("%d")
  end

end
end

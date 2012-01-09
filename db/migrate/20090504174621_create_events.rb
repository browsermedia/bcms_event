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
  end

  def self.down
    ContentType.delete_all(['name = ?', 'Event'])
    CategoryType.all(:conditions => ['name = ?', 'Event']).each(&:destroy)
    drop_table :event_versions
    drop_table :events
  end
end

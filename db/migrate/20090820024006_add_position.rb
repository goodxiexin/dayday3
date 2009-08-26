class AddPosition < ActiveRecord::Migration
  def self.up
    add_column :photos, :position, :integer
    add_column :blogs, :position, :integer
    add_column :videos, :position, :integer 
  end

  def self.down
    remove_column :photos, :position
    remove_column :videos, :position
    remove_column :blogs, :position
  end
end

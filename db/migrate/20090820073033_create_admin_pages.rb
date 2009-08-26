class CreateAdminPages < ActiveRecord::Migration
  def self.up
    create_table :admin_pages do |t|
      t.string :title
      t.string :permalink
      t.text :body

      t.timestamps
    end
  end

  def self.down
    drop_table :admin_pages
  end
end

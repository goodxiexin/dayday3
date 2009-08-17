class CreateIcons < ActiveRecord::Migration
  def self.up
    create_table :icons, :force => true do |t|
      t.integer :user_id
      t.boolean :current

      # required by attachment_fu
      t.integer :parent_id
      t.string :content_type
      t.string :filename
      t.string :thumbnail
      t.integer :size
      t.integer :width
      t.integer :height

      t.timestamps
    end
  end

  def self.down
    drop_table :icons
  end
end

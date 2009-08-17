class CreateMails < ActiveRecord::Migration
  def self.up
    create_table :mails, :force => true do |t|
      t.integer :sender_id
      t.integer :receiver_id
      t.boolean :delete_by_sender, :default => false
      t.boolean :delete_by_receiver, :default => false
      t.boolean :read_by_sender, :default => true
      t.boolean :read_by_receiver, :default => false
      t.string :title
      t.text :content
      t.integer :parent_id

      t.timestamps
    end
  end

  def self.down
    drop_table :mails
  end
end

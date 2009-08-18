class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages, :force => true do |t|
      t.string :title
      t.string :permalink
      t.text :body
      t.timestamps
    end
    Page.create(:title => "Dayday3 Home",
            :permalink => "welcome-page",
            :body => "Welcome to Dayday3")
  end

  def self.down
    drop_table :pages
  end
end

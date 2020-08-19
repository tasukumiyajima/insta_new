class AddSomeColumnToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :website, :text
    add_column :users, :introduction, :text
    add_column :users, :phone_number, :integer
    add_column :users, :sex, :integer
  end
end

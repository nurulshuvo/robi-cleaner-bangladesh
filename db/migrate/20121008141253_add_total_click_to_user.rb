class AddTotalClickToUser < ActiveRecord::Migration
  def change
    add_column :users, :total_click, :integer, :default => 0
  end
end

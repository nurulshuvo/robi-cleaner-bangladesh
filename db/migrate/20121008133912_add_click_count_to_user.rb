class AddClickCountToUser < ActiveRecord::Migration
  def change
    add_column :users, :click_count, :integer, :default => 0
  end
end

class AddPlayedToUser < ActiveRecord::Migration
  def change
    add_column :users, :played, :integer, :value => 0
  end
end

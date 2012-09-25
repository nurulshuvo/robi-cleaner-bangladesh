class ChangePointToUser < ActiveRecord::Migration
  def up
    change_column :users, :point
  end

  def down
  end
end

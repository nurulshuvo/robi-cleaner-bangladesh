class CreateCleans < ActiveRecord::Migration
  def change
    create_table :cleans do |t|
      t.integer :count

      t.timestamps
    end
  end
end

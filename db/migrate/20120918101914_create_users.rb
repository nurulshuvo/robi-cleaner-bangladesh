class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :uid
      t.string :token_field
      t.string :name
      t.string :point

      t.timestamps
    end
  end
end

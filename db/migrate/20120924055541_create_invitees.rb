class CreateInvitees < ActiveRecord::Migration
  def change
    create_table :invitees do |t|
      t.string :uid
      t.integer :user_id

      t.timestamps
    end
  end
end

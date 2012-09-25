class AddAcceptedToInvitee < ActiveRecord::Migration
  def change
    add_column :invitees, :accepted, :string
  end
end

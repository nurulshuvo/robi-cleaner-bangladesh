class AddAcceptedInvitationsToUser < ActiveRecord::Migration
  def change
    add_column :users, :accepted_invitation, :integer, :default => 0
  end
end

class User < ActiveRecord::Base
  attr_accessible :name, :point, :token_field, :uid
  has_many :invitees

  before_save :update_point


  def self.reset_point(point)
    @users = User.where("point > ?", point.to_s)
    @users.each {|u| u.point = 0; u.save}
  end


  private


  def update_point
    if self.click_count > 40  and self.point > 1600
       self.point = 0
       self.played=1
    end
  end


  def ban_user(point)
    if self.click_count > point
      self.point = 0
      self.played=1
    end
  end


end

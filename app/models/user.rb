class User < ActiveRecord::Base
  attr_accessible :name, :point, :token_field, :uid
  has_many :invitees

  before_save :update_point


  def self.reset_point(point)
    @users = User.where("point > ?", point.to_s)
    @users.each {|u| u.point = 0; u.save}
  end


  def self.ban_user(point)
    @users = User.where("click_count > ?", point.to_i)
    @users.each {|u| u.played = 1; u.point = 0; u.save; }
  end

  def self.ban_user_point(point)
    @users = User.where("point > ?", point.to_i)
    @users.each {|u| u.played = 1; u.point = 0; u.click_count = 400000; u.save; }
  end



  private


  def update_point
    if self.click_count > 50  and self.point > 1600
       self.point = 0
       self.played=1
    end
  end



end

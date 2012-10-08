class User < ActiveRecord::Base
  attr_accessible :name, :point, :token_field, :uid
  has_many :invitees

  before_save :update_point


  def self.reset_point(point)
    User.all.each do |u|
      if u.point > point.to_i
         u.point = 0
         u.save
      end
    end
  end


  private

  def update_point
    if click_count > 45
       point = 0
    end
  end


end

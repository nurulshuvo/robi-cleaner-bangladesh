class User < ActiveRecord::Base
  attr_accessible :name, :point, :token_field, :uid
end

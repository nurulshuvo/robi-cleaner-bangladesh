class FacebookController < ApplicationController

  before_filter :create_facebook_instance

  def landing_page
    protocol = request.protocol
    @facebook = Facebook.new(protocol)
    @authorized = @facebook.authorized?(request.params[:signed_request]) if request.params[:signed_request].present?
    if @authorized
      initialize_or_create_user(protocol)

    else
      render 'authorize_user', :layout => false
    end
  end

  def starting_page
    #@user = current_user
    #@graph = Koala::Facebook::API.new(@user.token_field)
  end


  def clean

  end

  def point
     request.params['point']
  end

  private

  def create_facebook_instance(protocol = nil)
    protocol = request.protocol if protocol.nil?
    @facebook = Facebook.new(protocol)
  end

  def initialize_or_create_user(protocol)
    @facebook = Facebook.new(protocol)
    @token = @facebook.parse_signed_request(request.params[:signed_request])['oauth_token']
    @graph = Koala::Facebook::API.new(@token)
    @user = User.find_or_create_by_uid(@graph.get_object('me')['id'])
    @user.update_attribute(:token_field, @token)
    session[:user_id] = @user.id
  end

  def authorize_user
    respond_to do |format|
      format.js render :layout => false
    end
  end
end

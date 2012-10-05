class FacebookController < ApplicationController
   before_filter :create_facebook_instance

  def landing_page
    protocol = request.protocol
    @facebook = Facebook.new(protocol)
    @authorized = @facebook.authorized?(request.params[:signed_request]) if request.params[:signed_request].present?
    if @authorized
      session[:user_id] = initialize_or_create_user(protocol)
      render 'redirect_to_fan_page', :layout => false
    else
      render 'authorize_user', :layout => false
    end
  end

   def fan_page
     protocol = request.protocol
     @facebook = Facebook.new(protocol)
     @authorized = @facebook.authorized?(request.params[:signed_request]) if request.params[:signed_request].present?
     if @authorized
       session[:user_id] = initialize_or_create_user(protocol)
     else
       render 'authorize_user', :layout => false
     end
   end

  def rules

  end
  def invite

  end
  def result
    @users = User.where('point is not ?', nil).order('point DESC')
  end

  def clean
       @user = current_user
       @user.point = 0;
       @user.save
  end

  def point
    @user = current_user
    @user.point= 0 if @user.point.nil?
    @user.point+=(request.params[:point]).to_i
    if @user.point and @user.point < 12000
        @user.save
     end
  end

   def post_invitation_process
     @invited_ids = params[:to].split(',').to_a
     @user = current_user
     @invited_ids.each do |uid|
       @user.invitees.create(:uid => uid)
     end
     redirect_to facebook_result_path
   end

   def to_invite
     redirect_to facebook_invite_path
   end

   def not_liked_page
     @graph = Koala::Facebook::GraphAPI.new(current_user.token_field)
     @status = !@graph.get_connections("me","likes/#{ENV['fan_page_id']}").empty?
     render :text => @status
   end

   def link1
     @user = User.find(current_user.id)
     @user.point = 0
     @user.save
     render :text => current_user.point, :layout => false
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
    name = @graph.get_object('me')['name']
    @user.update_attribute(:token_field, @token)
    @user.update_attribute(:name, name)
    session[:user_id] = @user.id
  end


  def authorize_user
    respond_to do |format|
      format.js render :layout => false
    end
  end
end

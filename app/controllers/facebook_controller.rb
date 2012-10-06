class FacebookController < ApplicationController
   before_filter :create_facebook_instance, :except => [:rank]

   layout :selected_layout

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
        @user = current_user
        @user.played=0;
        @user.save
  end
  def invite
      @user = current_user
      @user.played = 1
      @user.save
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
    if !(@user.played == 1) and @user.point and @user.point < 2250
        @user.save
    end
    params[:point] = nil
    params.delete(:point)
  end

   def post_invitation_process
     @invited_ids = params[:to].split(',').to_a
     default_number_of_invitee = 20
     current_number_of_invitee = @invited_ids.size.to_i
     extra_invitee_invited = (current_number_of_invitee - default_number_of_invitee).to_i
     bonus_point = (extra_invitee_invited*10)
     @user = current_user
     @user.point += bonus_point
     @user.save
     @invited_ids.each do |uid|
       @user.invitees.create(:uid => uid)
     end
     redirect_to facebook_result_path
   end

   def to_invite
     @user = current_user
     @user.played = 1
     @user.save
     redirect_to facebook_invite_path
   end

   def not_liked_page
     @graph = Koala::Facebook::GraphAPI.new(current_user.token_field)
     @status = !@graph.get_connections("me","likes/#{ENV['fan_page_id']}").empty?
     render :text => @status
   end

   def link1
     @user = User.find(current_user.id)
     @user.played = 1
     @user.save
     render :text => current_user.played, :layout => false
   end

   def rank
     @users = User.where('point is not ?', nil).order('point DESC')
   end

  private

   def selected_layout
     if action_name == 'rank'
       'rank'
     else
       'application'
     end
   end

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

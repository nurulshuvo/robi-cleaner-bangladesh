class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_header

  def like_client_page?
    if current_user
    @graph = Koala::Facebook::GraphAPI.new(current_user.token_field)
    !@graph.get_connections("me","likes/#{ENV['fan_page_id']}").empty?
    end
  end


  def current_user
    @current_user = User.find(session[:user_id]) if !session[:user_id].blank?
  end
  helper_method :current_user

  def login_required
      redirect_to "/auth/facebook/?state=canvas" unless current_user
  end
  helper_method :login_required

  def graph
    @graph = Koala::Facebook::GraphAPI.new(current_user.token_field)
  end
  helper_method :graph

  def set_header
    response.headers['P3P'] = 'CP="CAO PSA OUR"'
  end

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    new_admin_session_path
  end
end

module ApplicationHelper
  def like_client_page?
    @graph = Koala::Facebook::GraphAPI.new(current_user.token_field)
    !@graph.get_connections("me","likes/#{ENV['fan_page_id']}").empty?
  end
end

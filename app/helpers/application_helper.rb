module ApplicationHelper
  def like_castrol_page?
    @graph = Koala::Facebook::GraphAPI.new(current_user.token_field)
    @graph.get_connections("me","likes/237560939649216").empty?
  end
end

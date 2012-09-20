class Facebook

  def initialize(http_protocol)
    @app_id = ENV['app_id']
    @app_secret = ENV['app_secret']
    @app_url = http_protocol+ENV['app_url']
    @permissions = ['email', 'publish_stream', 'read_friendlists'].join(',')
    @oauth = Koala::Facebook::OAuth.new("#{@app_id}", "#{@app_secret}", "#{@app_url}")
  end

  def get_code
    @url = @oauth.url_for_oauth_code(:permissions=> @permissions )
  end

  def parse_signed_request(signed_request)
    @oauth.parse_signed_request(signed_request)
  end

  def authorized?(signed_request)
    @oauth = Koala::Facebook::OAuth.new("#{@app_id}", "#{@app_secret}", "#{@app_url}")
    !@oauth.parse_signed_request(signed_request)['oauth_token'].nil?
  end


  def get_access_token(code)
    @token = @oauth.get_access_token(code)
  end

  def user_id

  end

  def friend_info(friend_id = nil)
  end

  def friend_picture

  end
end
class Auth < Rack::Auth::Basic
  def call(env)
    request = Rack::Request.new(env)
    action = request.path_info.split('/')[1] if request.path_info
    manage_actions = %W(edit create revert rename upload uploadFile delete)
    ignore_actions = ["/create/custom.css", "/create/custom.js"]
    unless manage_actions.include?(action) && !ignore_actions.include?(request.path_info)
      @app.call(env)
    else
      super
    end
  end
end

class Precious::App
  basic_auth_username = ENV['BASIC_AUTH_USERNAME']
  basic_auth_password = ENV['BASIC_AUTH_PASSWORD']
  basic_auth_manage = ENV['BASIC_AUTH_MANAGE_ONLY']
  if basic_auth_username && basic_auth_password
    if basic_auth_manage
      use Auth do |username, password|
        [username, password] == [basic_auth_username, basic_auth_password]
      end
    else
      use Rack::Auth::Basic, "Restricted Area" do |username, password|
        [username, password] == [basic_auth_username, basic_auth_password]
      end
    end
  end
end

require './auth'

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

module Precious
  class App < Sinatra::Base
    basic_auth_username = ENV['BASIC_AUTH_USERNAME']
    basic_auth_password = ENV['BASIC_AUTH_PASSWORD']
    basic_auth_manage = ENV['BASIC_AUTH_MANAGE_ONLY']
    if basic_auth_username && basic_auth_password
      if basic_auth_manage
        manage_actions = ["/edit/*", "/create/*", "/revert/*", "/rename/*", "/upload/*", "/uploadFile/*", "/delete/*"]
        ignore_actions = ["/create/custom.css", "/create/custom.js"]
        manage_actions.each do |path|
          before path do
            request = Rack::Request.new(env)
            authorize unless ignore_actions.include?(request.path_info)
          end
        end
      else
        before do
          authorize
        end
      end
    end

    private
    def authorize
      response['WWW-Authenticate'] = %(Basic realm="Restricted area.")
      throw(:halt, [401, "Not authorized\n"]) unless authorized?
    end

    def authorized?
      basic_auth_username = ENV['BASIC_AUTH_USERNAME']
      basic_auth_password = ENV['BASIC_AUTH_PASSWORD']

      @auth ||=  Rack::Auth::Basic::Request.new(request.env)
      @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == [basic_auth_username, basic_auth_password]
    end
  end
end

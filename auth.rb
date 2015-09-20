class Auth < Rack::Auth::Basic
  def call(env)
    request = Rack::Request.new(env)
    action = request.path_info.split('/')[1] if request.path_info
    basic_auth_manage_action = %W(edit create revert rename upload uploadFile delete)
    ignore_action = ["/create/custom.css", "/create/custom.js"]
    unless basic_auth_manage_action.include?(action) && !ignore_action.include?(request.path_info)
      @app.call(env)
    else
      super
    end
  end
end

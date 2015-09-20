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

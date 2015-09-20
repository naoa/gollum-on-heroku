require './app'

$stdout.sync = true

app = App.new
repos = app.set_repos
routes = app.set_routes
app.set_hook repos

run Rack::URLMap.new(routes)

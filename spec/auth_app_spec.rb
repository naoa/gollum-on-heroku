ENV["BASIC_AUTH_USERNAME"] = "test"
ENV["BASIC_AUTH_PASSWORD"] = "test"

require './spec/spec_helper'
require './app'

describe "AuthApp" do
  include Rack::Test::Methods
  include SpecHelper

  def app
    app = App.new
    repos = app.set_repos
    routes = app.set_routes
    app.set_hook repos
    Rack::URLMap.new(routes)
  end

  before do
    reset_env
    set_env
    create_repo ENV['GIT_REPO_URL_1']
  end
  describe 'when authroized' do
    before do
      basic_authorize 'test', 'test'
    end
    context '/' do
      before { get '/' }
      it 'returns 302' do
        expect(last_response.status).to eq 302
      end
    end
    context '/create/test' do
      before { get '/create/test' }
      it 'returns 200' do
        expect(last_response.status).to eq 200
      end
    end
  end
  describe 'when not authroized' do
    context '/' do
      before { get '/' }
      it 'returns 401' do
        expect(last_response.status).to eq 401
      end
    end
    context '/create/test' do
      before { get '/create/test' }
      it 'returns 401' do
        expect(last_response.status).to eq 401
      end
    end
  end
  after do
    remove_repo ENV['GIT_REPO_URL_1']
    reset_env
  end
end

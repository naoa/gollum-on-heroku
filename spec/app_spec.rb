require './spec/spec_helper'
require './app'

describe "App" do
  include Rack::Test::Methods
  include SpecHelper

  def app
    app = App.new
    repos = app.set_repos
    routes = app.set_routes
    app.set_hook repos
    Rack::URLMap.new(routes)
  end

  describe 'when num of repo is 1' do
    before do
      reset_env
      set_env
      create_repo ENV['GIT_REPO_URL_1']
    end
    context '/' do
      before { get '/' }
      it 'returns 302' do
        expect(last_response.status).to eq 302
      end
      it 'redirect to Home' do
        expect(last_response.location).to eq 'http://example.org/Home'
      end
    end
    context '/test' do
      before { get '/test' }
      it 'returns 302' do
        expect(last_response.status).to eq 302
      end
      it 'redirect to create/test' do
        expect(last_response.location).to eq 'http://example.org/create/test'
      end
    end
    after do
      remove_repo ENV['GIT_REPO_URL_1']
      reset_env
    end
  end

  describe 'when num of repo is 2' do
    before do
      reset_env
      set_env
      set_env2
      create_repo ENV['GIT_REPO_URL_1']
      create_repo ENV['GIT_REPO_URL_2']
    end
    context '/' do
      before { get '/' }
      it 'returns 404' do
        expect(last_response.status).to eq 404
      end
    end
    context '/test' do
      before { get '/test' }
      it 'returns 302' do
        expect(last_response.status).to eq 302
      end
      it 'redirect to /test/Home' do
        expect(last_response.location).to eq 'http://example.org/test/Home'
      end
    end
    after do
      remove_repo ENV['GIT_REPO_URL_1']
      remove_repo ENV['GIT_REPO_URL_2']
      reset_env
    end
  end
  describe 'when repo is bare' do
    before do
      reset_env
      set_env
      ENV['GIT_REPO_URL_1'] += ".git"
      create_bare_repo ENV['GIT_REPO_URL_1']
    end
    context '/' do
      before { get '/' }
      it 'returns 302' do
        expect(last_response.status).to eq 302
      end
      it 'redirect to Home' do
        expect(last_response.location).to eq 'http://example.org/Home'
      end
    end
    after do
      remove_repo ENV['GIT_REPO_URL_1'] += ".git"
      reset_env
    end
  end
end

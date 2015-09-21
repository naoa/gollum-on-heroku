ENV['RACK_ENV'] = 'test'

require 'rack/test'
require 'rspec'

module SpecHelper
  def create_repo gollum_path
    unless File.exists? "#{gollum_path}/.git"
      repo = Grit::Repo.init(gollum_path)
      repo.add('.')
      repo.commit_all('Create gollum wiki')
    end
  end

  def create_bare_repo gollum_path
    unless File.exists? "#{gollum_path}/.git"
      repo = Grit::Repo.init(gollum_path, {is_bare: true})
      repo.add('.')
      repo.commit_all('Create gollum wiki')
    end
  end

  def remove_repo gollum_path
    FileUtils.rm_rf(gollum_path) if File.exists? "#{gollum_path}/.git"
  end

  def reset_env
    ENV.each do |e|
      ENV.delete(e[0]) if e[0] =~ /^GIT_REPO_URL_[0-9]+$/
      ENV.delete(e[0]) if e[0] =~ /^GITHUB_TOKEN$/
      ENV.delete(e[0]) if e[0] =~ /^AUTHOR_[A-z_]+$/
      ENV.delete(e[0]) if e[0] =~ /^GOLLUM_[A-z_]+$/
      ENV.delete(e[0]) if e[0] =~ /^BASIC_AUTH_[A-z_]+$/
    end
  end

  def set_env
    ENV["GITHUB_TOKEN"] = "test"
    ENV["GIT_REPO_URL_1"] = "test"
    ENV["AUTHOR_NAME"] = "test"
    ENV["AUTHOR_EMAIL"] = "test"
  end

  def set_env2
    ENV["GIT_REPO_URL_2"] = "test2"
  end
end

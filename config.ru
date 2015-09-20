require 'uri'
require 'gollum/app'
require 'octokit'

$stdout.sync = true

repo_urls = ENV.collect { |e| e[1] if e[0] =~ /^GIT_REPO_URL_[0-9]+$/ }.compact!
github_token = ENV['GITHUB_TOKEN']
author_email = ENV['AUTHOR_EMAIL']
author_name = ENV['AUTHOR_NAME']
gollum_universal_toc = ENV['GOLLUM_UNIVERSAL_TOC'] || false
gollum_allow_editing = ENV['GOLLUM_ALLOW_EDITING'] || true
gollum_live_preview = ENV['GOLLUM_LIVE_PREVIEW'] || true
gollum_allow_uploads = ENV['GOLLUM_ALLOW_UPLOADS'] || true
gollum_show_all = ENV['GOLLUM_SHOW_ALL'] || true
gollum_collapse_tree = ENV['GOLLUM_COLLAPSE_TREE'] || false

gollum_h1_title = false
gollum_user_icons = 'none'
gollum_css = true
gollum_js = true
gollum_template_dir = nil

`git config --global credential.helper store`
`echo https://#{github_token}:x-oauth-basic@github.com >> ~/.git-credentials` if github_token

class Precious::App
  basic_auth_username = ENV['BASIC_AUTH_USERNAME']
  basic_auth_password = ENV['BASIC_AUTH_PASSWORD']
  if basic_auth_username && basic_auth_password
    use Rack::Auth::Basic, "Restricted Area" do |username, password|
      [username, password] == [basic_auth_username, basic_auth_password]
    end
  end
end

routes = {}
repos = {}

repo_urls.each do |repo_url|
  repo_uri = URI.parse(repo_url) 
  repo_name = File.basename(repo_uri.path)
  unless File.exists? "#{repo_name}"
    gritty = Grit::Git.new(repo_name)
    gritty.clone({:branch => 'master'}, "#{repo_url}", repo_name)
    unless File.exists? "#{repo_name}"
      if github_token
        client = Octokit::Client.new access_token: github_token
        client.create_repo(repo_name, auto_init: true, description: 'Wiki source for Gollum')
        gritty.clone({:branch => 'master'}, "#{repo_url}", repo_name)
      end
    end
  end
  repos[repo_name] = Grit::Repo.new(repo_name)
  raise "Not found repository" unless repos[repo_name]

  repos[repo_name].config['user.email'] = author_email
  repos[repo_name].config['user.name'] = author_name

  m = Module.new
  m.const_set :'App', Class.new(Precious::App)

  m::App.set(:default_markup, :markdown)
  m::App.set(:wiki_options, {
    css: gollum_css,
    js: gollum_js,
    allow_editing: gollum_allow_editing,
    live_preview: gollum_live_preview,
    allow_uploads: gollum_allow_uploads, 
    h1_title: gollum_h1_title,
    show_all: gollum_show_all,
    collapse_tree: gollum_collapse_tree,
    user_icons: gollum_user_icons,
    template_dir: gollum_template_dir,
    universal_toc: gollum_universal_toc
  })

  m::App.set(:gollum_path, repo_name)

  if repo_urls.length == 1
    routes["/"] = m::App.new
  else
    routes["/#{repo_name}"] = m::App.new
  end
end

Gollum::Hook.register(:post_commit, :hook_id) do |commiter, sha1|
  repo_urls.each do |repo_url|
    repo_name = File.basename(repo_url)
    if commiter.wiki.repo.path == repos[repo_name].path
      commiter.wiki.repo.git.push("#{repo_url}", 'master')
    end
  end
end

run Rack::URLMap.new(routes)

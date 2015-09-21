require 'uri'
require 'gollum/app'
require 'octokit'
require './precious'

class App
  def initialize
    @repo_urls = ENV.collect { |e| e[1] if e[0] =~ /^GIT_REPO_URL_[0-9]+$/ }.compact!

    @github_token = ENV['GITHUB_TOKEN']
    @author_email = ENV['AUTHOR_EMAIL']
    @author_name = ENV['AUTHOR_NAME']

    @gollum_universal_toc = ENV['GOLLUM_UNIVERSAL_TOC'] ? !ENV['GOLLUM_UNIVERSAL_TOC'].downcase.eql?("true".downcase) : false
    @gollum_allow_editing = ENV['GOLLUM_ALLOW_EDITING'] ? !ENV['GOLLUM_ALLOW_EDITING'].downcase.eql?("false".downcase) : true
    @gollum_live_preview = ENV['GOLLUM_LIVE_PREVIEW'] ? !ENV['GOLLUM_LIVE_PREVIEW'].downcase.eql?("true".downcase) : false
    @gollum_allow_uploads = ENV['GOLLUM_ALLOW_UPLOADS'] ? !ENV['GOLLUM_ALLOW_UPLOADS'].downcase.eql?("false".downcase) : true
    @gollum_show_all = ENV['GOLLUM_SHOW_ALL'] ? !ENV['GOLLUM_SHOW_ALL'].downcase.eql?("false".downcase) : true
    @gollum_collapse_tree = ENV['GOLLUM_COLLAPSE_TREE'] ? !ENV['GOLLUM_COLLAPSE_TREE'].downcase.eql?("true".downcase) : false
    @gollum_is_bare = ENV['GOLLUM_IS_BARE'] ? !ENV['GOLLUM_IS_BARE'].downcase.eql?("false".downcase) : true

    @gollum_h1_title = false
    @gollum_user_icons = 'none'
    @gollum_css = true
    @gollum_js = true
    @gollum_template_dir = nil

    `git config --global credential.helper store`
    `echo https://#{@github_token}:x-oauth-basic@github.com > ~/.git-credentials` if @github_token
  end

  def set_repos
    repos = {}
    @repo_urls.each do |repo_url|
      repo_name = File.basename(repo_url)
      unless File.exists?(repo_name)
        git = Grit::Git.new(repo_name)
        git.clone({branch: 'master', bare: @gollum_is_bare}, repo_url, repo_name)
        if @github_token && !File.exists?(repo_name)
          create_repo(repo_name)
          git.clone({branch: 'master', bare: @gollum_is_bare}, repo_url, repo_name)
        end
      end
      repos[repo_name] = Grit::Repo.new(repo_name, {is_bare: @gollum_is_bare})
      raise "Not found repository" unless repos[repo_name]

      repos[repo_name].config['user.email'] = @author_email
      repos[repo_name].config['user.name'] = @author_name
    end
    repos
  end

  def set_routes
    routes = {}
    @repo_urls.each do |repo_url|
      repo_name = File.basename(repo_url)
      m = Module.new
      m.const_set :'App', Class.new(Precious::App)

      m::App.set(:default_markup, :markdown)
      m::App.set(:wiki_options, {
        css: @gollum_css,
        js: @gollum_js,
        allow_editing: @gollum_allow_editing,
        live_preview: @gollum_live_preview,
        allow_uploads: @gollum_allow_uploads,
        h1_title: @gollum_h1_title,
        show_all: @gollum_show_all,
        collapse_tree: @gollum_collapse_tree,
        user_icons: @gollum_user_icons,
        template_dir: @gollum_template_dir,
        universal_toc: @gollum_universal_toc,
        repo_is_bare: @gollum_is_bare
      })
      m::App.set(:gollum_path, repo_name)

      if @repo_urls.length == 1
        routes["/"] = m::App.new
      else
        routes["/#{repo_name}"] = m::App.new
      end
    end
    routes
  end

  def set_hook repos
    return unless @github_token
    Gollum::Hook.register(:post_commit, :hook_id) do |commiter, sha1|
      @repo_urls.each do |repo_url|
        repo_name = File.basename(repo_url)
        if commiter.wiki.repo.path == repos[repo_name].path
          commiter.wiki.repo.git.push(repo_url, 'master')
        end
      end
    end
  end

  private
  def create_repo repo_name
    client = Octokit::Client.new access_token: @github_token
    client.create_repo(repo_name, auto_init: true, description: 'Wiki source for Gollum')
  end
end

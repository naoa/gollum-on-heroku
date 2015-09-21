# Gollum on Heroku
auto generate git powered wiki ([Gollum](https://github.com/gollum/gollum)) to Heroku.

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

* sync to GitHub
* simple basic authentication
* can use multi git source

### Use Deploy to Heroku button

* Click Deploy to Heroku button
* Fill App name
* Fill environment variables

| variable | description | 
| -------- |  ----------- |
| GITHUB_TOKEN | An access key for GitHub. If this field is empty, updated data will be deleted after reboot dyno. |
| GIT_REPO_URL_1 | Git repository URL. e.g https://github.com/naoa/test https://github.com/naoa/test.wiki|
| GIT_REPO_URL_2~  | Git repository URL. any num is ok. |
| AUTHOR_NAME |  |
| AUTHOR_EMAIL |  |
| BASIC_AUTH_USERNAME | if need protect by basic authentication |
| BASIC_AUTH_PASSWORD | if need protect by basic authentication |
| BASIC_AUTH_MANAGE_ONLY | if need protect only manage actions such as edit/create. |
| GOLLUM_UNIVERSAL_TOC | default: false |
| GOLLUM_ALLOW_EDITING | default: true |
| GOLLUM_LIVE_PREVIEW | default: false |
| GOLLUM_ALLOW_UPLOADS | default: true |
| GOLLUM_SHOW_ALL | default: true |
| GOLLUM_COLLAPSE_TREE | default: false |
| GOLLUM_IS_BARE | "git repository URL must include .git default: false |

* Add heroku repository(if need)

```
git clone git@heroku.com:[App name].git
cd [App name]
git remote add heroku git@heroku.com:[App name].git
```

### Use local

```
bundle exec rackup config.ru
```

### URL mapping

* 1 repository
```
  https://[App_name].herokuapp.com/ -> repo_1
```

* over 2 repositories
```
  https://[App_name].herokuapp.com/repo_1 -> repo_1
  https://[App_name].herokuapp.com/repo_2 -> repo_2
```

### License

MIT

### Authors

Naoya Murakami

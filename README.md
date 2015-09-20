# Gollum on Heroku
auto generated git powered wiki ([Gollum](https://github.com/gollum/gollum)) to Heroku.

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

# Use Deploy to Heroku button

* Click Deploy to Heroku button
* Fill App name
* Fill environment variables

| variable | description | 
| -------- |  ----------- |
| GITHUB_TOKEN | need this if update via heroku |
| GIT_REPO_URL_1 | e.g https://github.com/naoa/test https://github.com/naoa/test.wiki|
| GIT_REPO_URL_2~  | any num is ok. |
| AUTHOR_NAME |  |
| AUTHOR_EMAIL |  |
| BASIC_AUTH_USERNAME | |
| BASIC_AUTH_PASSWORD | |
| BASIC_AUTH_MANAGE_ONLY |  |
| GOLLUM_UNIVERSAL_TOC |  |
| GOLLUM_ALLOW_EDITING |  |
| GOLLUM_LIVE_PREVIEW |  |
| GOLLUM_ALLOW_UPLOADS |  |
| GOLLUM_SHOW_ALL |  |
| GOLLUM_COLLAPSE_TREE |  |

* Add heroku repository

```
git clone git@heroku.com:[App name].git
cd [App name]
git remote add heroku git@heroku.com:[App name].git
```

# Use local

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


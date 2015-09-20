# Gollum on Heroku
auto generated git powered wiki ([Gollum](https://github.com/gollum/gollum)) for Heroku.

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

# Use Deploy to Heroku button

* Click Deploy to Heroku button
* Fill App name
* Fill environment variables

| variable | requirement | description | 
| -------- | ----------- | ----------- |
| GITHUB_TOKEN |  | need this if update from heroku |
| GIT_REPO_URL_1 | true | e.g https://github.com/naoa/test https://github.com/naoa/test.wiki|
| GIT_REPO_URL_2~  |  |  |
| AUTHOR_NAME |  |  |
| AUTHOR_EMAIL |  |  |
| BASIC_AUTH_USERNAME |  |  |
| BASIC_AUTH_PASSWORD |  |  |
| BASIC_AUTH_MANAGE_ONLY |  |  |
| GOLLUM_UNIVERSAL_TOC |  |  |
| GOLLUM_ALLOW_EDITING |  |  |
| GOLLUM_LIVE_PREVIEW |  |  |
| GOLLUM_ALLOW_UPLOADS |  |  |
| GOLLUM_SHOW_ALL |  |  |
| GOLLUM_COLLAPSE_TREE |  |  |

* Access to https://[App name].herokuapp.com/[GIT_REPO_URL_[0-9]+]

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

#SmartibuyAPI

Web service of Smartibuy based on sinatra.  
[![Build Status](https://travis-ci.org/Smartibuy/SmartibuyAPI.svg?branch=master)](https://travis-ci.org/Smartibuy/SmartibuyAPI)

# For development

After clone this repository, use `bundle` to install all dependences

```sh
$ bundle install
```
Use `rackup` to run the web app  (default port is 9292)
and visit the website http://localhost:port (http://localhost:9292)
that tells you the current API version and Github homepage of API.

```sh
$ rackup config.ru -p [port]
Thin web server (v1.6.4 codename Gob Bluth)
Maximum connections set to 1024
Listening on localhost:[port], CTRL+C to stop
```
Your web service offers the following routes

```sh
# Show all good infomation in the certian FB group
$ curl -GET http://127.0.0.1:3000/api/v1/all_data/[facebook group id].json
  # $ curl -GET http://127.0.0.1:3000/api/v1/all_data/817620721658179.json

# Search the certain good info. by good ID
$ curl -v -H "Accept: application/json" -H "Content-type: application/json" -X GET -d "{\"group_id\":\"[group id]\", \"good_id\":\"[good id]\"}" http://localhost:3000/api/v1/data/search
  # $ curl -v -H "Accept: application/json" -H "Content-type: application/json" -X GET -d "{\"group_id\":\"817620721658179\", \"good_id\":\"817620721658179_909156159171301\"}" http://localhost:3000/api/v1/data/search

```

Run testing

```sh
$ rake spec
```

LICENSE
==
MIT @ Smartibuy

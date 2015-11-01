#SmartibuyAPI

[ ![Codeship Status for Smartibuy/SmartibuyAPI](https://codeship.com/projects/4df54750-62b8-0133-c7a9-32b67f1e3a7d/status?branch=master)](https://codeship.com/projects/112664)


https://codeship.com/projects/YOUR_PROJECT_UUID/status?branch=master

Web service of Smartibuy based on sinatra. （Deployed on Codeship）
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
Run testing

```sh
$ rake spec
```


# API usage
**GET /api/v1/**
- functionality: 
  - show our service status such as vesrion and alive
- response : 
  - 200, show version
- example:
```bash
 curl -GET http://127.0.0.1:3000/api/v1/
```
**GET /api/v1/fb_data/[facebook group id].json**
- functionality: 
  - Show all good infomation in the certian FB group
- response : 
  - 200, return in **application/json** format
  - 404, the facebook group is not existed.
- example:
```bash
 curl -GET http://127.0.0.1:3000/api/v1/fb_data/817620721658179.json
```

**POST /api/v1/fb_data/search**
- functionality: 
  - Search the certain good info. by good ID
- request : 
  - Content-type: application/json
```
  {
    "group_id":"[Group_id]", # (string) facebook id
    "good_id":"[Good_id]" # (string) good id
  }
```
- response : 
  - 200, return in **application/json** format
  - 400, request not in json format
- example:

```bash
$ curl -v -H "Accept: application/json" -H "Content-type: application/json" -X GET -d "{\"group_id\":\"817620721658179\", \"good_id\":\"817620721658179_909156159171301\"}" http://localhost:3000/api/v1/fb_data/search
```



LICENSE
==
MIT @ Smartibuy

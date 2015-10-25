#SmartibuyAPI
==
Web service of Smartibuy based on sinatra.

# For development

After clone this repository, use `bundle` to install all dependences

```sh
$ bundle install
```
Use `rackup` to run the web app  (default port is 9292)
visit the website http://localhost:port (http://localhost:9292)

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

LICENSE
==
MIT @ Smartibuy

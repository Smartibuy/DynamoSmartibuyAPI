#DynamoSmartibuyAPI
**Fork from SmartibuyAPI**

[ ![Codeship Status for Smartibuy/SmartibuyAPI_dynamo](https://codeship.com/projects/a0e21290-83ac-0133-0c7b-2e117485f168/status?branch=master)](https://codeship.com/projects/121804)

Web service of Smartibuy based on sinatra. （Deployed with Codeship）

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

**If you want to run in test environment.**
```sh
$ rackup config.ru -p <port> -E test
```

**Run testing**
```sh
$ rake spec
```

**DynamoDB Configuration**
You have required to set up the aws credential on `codeship` and `heroku`  
We use `env_config` gem to set the credential to heroku remotely.  
```
$ rake config_env:heroku[smartibuyapidynamo] # setting config
$ RACK_ENV=production rake db:migrate
```

# API usage
**GET /**
- functionality:
  - show our service status such as vesrion and alive
- response :
  - 200, show version
- example:
```bash
 curl -GET http://127.0.0.1:3000/
```
**GET /api/v1/fb_data/shops**
- functionality:
  - supported and parsed shops
- response :
  - 200, parsed shops
- example:
```bash
 curl -GET http://127.0.0.1:3000/api/v1/fb_data/shops
```
- example output
```
{
  "data": [
    {
      "name": "二手智慧型手機,平板交流",
      "privacy": "OPEN",
      "id": "1730742887066429"
    },
    {
      "name": "大台南二手交流、買賣公開社團",
      "privacy": "OPEN",
      "id": "144498012423141"
    },
    {
      "name": "新竹二手跳蚤市場",
      "privacy": "OPEN",
      "id": "107793636088378"
    },
    {
      "name": "交大二手大賣場",
      "privacy": "OPEN",
      "id": "191505604299442"
    }
  ]
```


**(Depreciated) GET /api/v1/fb_data/[facebook group id].json**
- please move to use  `GET /api/v1/fb_data/[facebook group id]/goods?timestamp=[timestamp]&page=[page_token]`
- functionality:
  - Show all good infomation in the certian FB group
- response :
  - 200, return in **application/json** format
  - 404, the facebook group is not existed.
- example:
```bash
 curl -GET http://127.0.0.1:3000/api/v1/fb_data/817620721658179.json
```

**GET /api/v1/fb_data/[facebook group id]/goods?timestamp=[timestamp]&page=[page_token]**
- functionality:
  - Show all good infomation in the certian FB group by paging cursor
  - Give next page infomation to client
- parameter
  - [facebook group id] : fb group id
  - timestamp: (optional)timestamp, given by this api call to get specified page
  - page: (optional) page_token, given by this api call to get specified page
  - NOTE:if timestamp or page is not specified, it will return 25 post of specified group from the first one
- response code:
  - 200, return in **application/json** format
  - 404, the facebook group is not existed.
- example:
```bash
 curl -GET http://127.0.0.1:3000/api/v1/fb_data/817620721658179/goods?timestamp=[timestamp]&page=[page_token]
 curl -GET http://127.0.0.1:3000/api/v1/fb_data/817620721658179/goods
```
- response data format when reponse code is 200OK:
```
{
  data:[{
    "id":"0000000_0000000", //feed id
    "message":"OOOO",
    "price":5000 # show if in parsed list in http://127.0.0.1:3000/api/v1/fb_data/shops
    "title":"sell ticket" # show if in parsed list in http://127.0.0.1:3000/api/v1/fb_data/shops
    "updated_time":"2015-11-08T00:00:00+0000",
    "attachments":[
       {"height":720, "src":"http://www.example.com", "width":405},...
    ], //post images
    "from":{
      "id":"000000000",//user's fbid
      "name":"My name", //user's fbname
      "picture":{"is_silhouette":false, "url":"http://www.example.com"} //user's profile picture
    },
    "like_count":0,
    "comment_count":0,
   },....],
  next:{
    "timestamp":[timestamp]
    "page":[page_token]
  },
  prev:{
    #reserve to prev cursor
  },
},
```

**GET /api/v1/fb_data/goods/[good_id]**
- functionality:
  - Show **one** good infomation in the certian FB group by paging cursor
- parameter
  - [good_id] : fb post id
- response code:
  - 200, return in **application/json** format
  - 404, the facebook group is not existed.
- example:
```bash
 curl -GET http://127.0.0.1:3000/api/v1/fb_data/817620721658179_940605626026354/goods
```
- response data format when reponse code is 200OK:
```
{
    "id":"0000000_0000000", //feed id
    "message":"OOOO",
    "updated_time":"2015-11-08T00:00:00+0000",
    "attachments":[
       {"height":720, "src":"http://www.example.com", "width":405},...
    ], //post images
    "from":{
      "id":"000000000",//user's fbid
      "name":"My name", //user's fbname
      "picture":{"is_silhouette":false, "url":"http://www.example.com"} //user's profile picture
    },
    "like_count":0,
    "comment_count":0,
   }
```
**GET /api/v1/fb_data/goods/[good_id]/comments?token=[token]&action=[after|before]**
- functionality:
  - Show comments of **one** good by paging cursor
- parameter
  - [good_id] : fb post id
  - action : should fill after if you want to get next page.
- response code:
  - 200, return in **application/json** format
  - 404, the facebook group is not existed.
- example:
```bash
 curl -GET http://127.0.0.1:3000/api/v1/fb_data/817620721658179_940605626026354/goods
```
- response data format when reponse code is 200OK:
```
{
  "data": [
    {"id":"...",
    "message":"...",
    "created_time":"2016-01-03T12:01:33+0000",
    "from":{
        "id":"1184030858291925",
        "name":"李欣瑜",
        "picture":{"is_silhouette":false,"url":"http://example.com"
      }
    },
    "like_count":0
    },....
  ]",
  "after": ..., #next page token
  "before": "..."
}
```
- note: After is null means next page is not exist



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
$ curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST -d "{\"group_id\":\"817620721658179\", \"good_id\":\"817620721658179_909156159171301\"}" http://localhost:3000/api/v1/fb_data/search
```

**GET /api/vi/group/:id**
- functionality:
 - Get group id and name by unique id.
- request:
  - method: GET
  - request url: `http://localhost:3000/api/v1/group/:id`
- reponse:
  - 200
  - 400 - Not found
```
{
  id: 5,
  group_name: "清交二手貨倉XD",
  group_id: "817620721658179"
}
```

**POST /api/v1/create_group**
- functionality:
  - Create a group with id and name.
- request :
  - Content-type: application/json
```
  {
    "group_id":"[Group_id]", # (string) facebook group id
    "group_name":"[Group_name]" # (string) group name
  }
```
- response :
  - 303, redirect to http://localhost:3000/api/v1/group/:id
  - 400, request not in json format
- example:

```bash
$ curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST -d "{\"group_id\":\"817620721658179\", \"group_name\":\"清交二手大拍賣XD\"}" http://localhost:3000/api/v1/create_group
```

**GET /api/vi/product/:id**
- functionality:
 - Get product's informations by unique id.
- request:
  - method: GET
  - request url: `http://localhost:3000/api/v1/product/:id`
- reponse:
  - 200
  - 400 - Not found
```
{
  product_title: "PONY 運動鞋",
  product_id: "817620721658179_914934681926782",
  fb_user_id: "rubyuser",
  product_information: "7-8 可穿",
  price: 0,
  group_id: "817620721658179"
}
```

**POST /api/v1/create_product**
- functionality:
  - Create a product with its informations.
- request :
  - Content-type: application/json
```
  {
    "product_id":"[Product ID]", # (string) Product ID
    "fb_user_id": "[FB User ID]", # (string) FB User ID
    "product_title": "[Product Title]", # (string) Product Title
    "product_information": "[Product INFO]", # (string) Product INFO
    "price": "[Product Price]", # (string) Product Pric
    "group_id": "[FB Group ID]", # (string) FB Group ID
    "pic_url": "[Picture URL]", # (string) Picture URL
    "update_time": "[Update Time]", # (string) Update Time
    "create_time": "[Create Time]", # (string) Create Time
    "created_at": "[Create at]", # (string) Create at
    "updated_at": "[Update at]" # (string) Update at
  }
```
- response :
  - 303, redirect to http://localhost:3000/api/v1/product/:id
  - 400, request not in json format
- example:

```bash
$ curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST -d "{\"product_id\":\"817620721658179_914934681926782\", \"fb_user_id\":\"rubyuser\", \"product_title\":\"PONY拖鞋\", \"product_information\":\"7-8成新\", \"price\":\"議價\", \"group_id\":\"817620721658179\", \"pic_url\":\"None\", \"update_time\":\"2015-11-08T05:41:08+0000\", \"create_time\":\"2015-11-08T05:41:08+0000\", \"create_at\":\"2015-11-08T05:41:08+0000\", \"update_at\":\"2015-11-08T05:41:08+0000\"}" http://localhost:3000/api/v1/create_product
```

**GET /api/v1/search_mobile01/:cate/:name/:num/result.json'**
- functionality:
 - Get product list from mobile01 using category and keyword.
 - :cate is category, in this example, category is 電腦資訊.
 - :name is keyword, in this example, name is iphone.
 - :number is the number of result you want to list.
- request:
  - method: GET
  - request url: `/api/v1/search_mobile01/電腦資訊/iphone/5/result.json`
- reponse:
  - 200
  - 400 - Not found
```
[
  {"name":"全新未拆 SP Slicon Power DDR3L 1600 4G 筆記型電腦 記憶體  B40CCD (1)　商品所在地:台北市","price":"  600元","num":"0","update_time":"2015-12-06"},
  {"name":"iPad mini 羅技 Logitech超薄鍵盤保護殼 黑色.1-3代通用  bluem23 (47)　商品所在地:台北市","price":"  7,299元","num":"2","update_time":"2015-12-06"},
  {"name":"Micron 固態硬碟SSD crucial 64GB（送中古INTEL X25-V 40GB）  歌丸にゃんこ (9)　商品所在地:新北市","price":"  28,900元","num":"0","update_time":"2015-12-06"},
  {"name":"ASUS ZENBOOK 13.3吋 Full HD 筆電 Notebook  pcmew (8)　商品所在地:新北市","price":"  2,500元","num":"0","update_time":"2015-12-06"},
  {"name":"金士頓 KHX1600C9D3K 12GX Hyper X系列  蝸牛小哥哥 (1)　商品所在地:基隆市","price":"  498元","num":"0","update_time":"2015-12-06"}]%
```


**POST /api/v1/add_keyword_to_search_queue/:keyword**
- functionality:
  - Push keyword into AWS keyword queue.
- request :
  - Content-type: application/json
- response:
  - 200
  - 400 - Not found
- example:
```bash
$ curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST http://127.0.0.1:9292/api/v1/add_keyword_to_search_queue/手機htc
```

**POST /api/v1/add_keyword_to_cate_queue/:cate**
- functionality:
  - Push category into AWS keyword queue.
- request :
  - Content-type: application/json
- response:
  - 200
  - 400 - Not found
- example:
```bash
$ curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST http://smartibuyapidynamo.herokuapp.com/api/v1/add_keyword_to_cate_queue/手機
```

**POST /api/v1/save_hot_key_word**
- functionality:
  - Save hot keywords into DB.
- request :
  - Content-type: application/json
- response:
  - 201
  - 400 - Not found
- example:
```bash
$ curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST -d "{\"key_data\":\"{"htc":1, "手機":2}\"}" http://localhost:9292/api/v1/save_hot_key_word
```

**POST /api/v1/save_hot_cate**
- functionality:
  - Save hot categories into DB.
- request :
  - Content-type: application/json
- response:
  - 201
  - 400 - Not found
- example:
```bash
$ curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST -d "{\"cate_data\":\"{"htc":1, "apple":2}\"}" http://localhost:9292/api/v1/save_hot_cate
```

**POST /api/v1/users/:userid**
- functionality:
  - ADD user info into DB
- request :
  - Content-type: application/json
  ```
    {
      "email":"[E-Mail]", # (string)
      "hashtag": [hashtag list], # (array)
    }
  ```
- response
  - 201
  - 400 - Not found
- example:
```bash
$ curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST -d "{\"email\":\"katy@qq\", \"hashtag\":[apple, 電腦]}" http://localhost:9292/api/v1/user/katy12
```

**GET /api/v1/users/:id'**
- functionality:
 - Get user info from db
- request:
  - method: GET
  - request url: `api/v1/get_user_date/:id`
- reponse:
  - 200
  - 500 - There is no this user info.
- example:
```bash
$ curl -GET http://127.0.0.1:9292/api/v1/user/katy12
$ {"id":"katy12","email":"katy@qq","hashtag":"[apple, 電腦]"}%
```
**GET /api/v1/users/**
- functionality:
 - Get all user info from db
- request:
  - method: GET
  - request url: `api/v1/user/:id`
- reponse:
  - 200
  - 500 - There is no this user info.
- example:
```bash
$ curl -GET http://127.0.0.1:9292/api/v1/user/
```


**POST /api/v1/users/:id/tags**
- functionality:
 - add one hashtag subscribe topic
- request:
  - method: POST
  - entity :
  ```
  {
    "tag": "string" /*only string*/
  }
  ```
- reponse:
  - 200 - OK success
  - 400 - request wrong format.
  - 409 - tag  exist
  - 404 - user does not exist
- example:
```bash
$ curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST -d "{\"hashtag\":\"衣服\"}" http://localhost:9292/api/v1/user/rubybaby/tag/
```

**Delete '/api/v1/users/:id/tags/:tag'**

- functionality:
 - delete one hashtag subscribe topic
- request:
  - method: Delete
  - param :
    - id : user_id
    - tag : tag name
  - reponse:
    - 200 - OK success
    - 400 - request wrong format.
    - 409 - tag not exist
    - 404 - user does not exist


LICENSE
==
The MIT License (MIT)

Copyright (c) 2015 Smartubuy

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

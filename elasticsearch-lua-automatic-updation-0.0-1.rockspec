package = "elasticsearch-lua-update-automation"
version = "0.0-1"
source = {
  url = "https://github.com/kritijha/elasticsearch-lua-update-automation"
}
description = {
  summary = "Extracting and parsing endpoint details from elasticsearch-lua and the official elasticsearch api to find the missing endpoints",
  detailed = [[
    The enpoints from elasticsearch api are comapred with the endpoints from elasticsearch-lua and the missing endpoints are given.
  ]],
  homepage = "https://github.com/kritijha/elasticsearch-lua-update-automation",
  license = "MIT"
}
dependencies = {
  "lua >= 5.1, < 5.4",
  "luasec",
  "lua-cjson"
}
build = {
  type = "builtin"
}

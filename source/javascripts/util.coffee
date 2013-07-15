rootURL = 'http://totalrecall.99cluster.com'

toQueryString = (json)->
  url = []
  for key, value of json
    url.push "#{encodeURIComponent(key)}=#{encodeURIComponent(value)}"

  url.join '&'

ajax = (options)->
  options.data ||= {}
  options.success ||= -> true
  options.dataType ||= 'html'
  options.url = rootURL + options.url

  xhr = new XMLHttpRequest()
  xhr.open options.method, options.url, true
  xhr.setRequestHeader "Content-type", "application/x-www-form-urlencoded"
  xhr.onreadystatechange = ->
    return if xhr.readyState != 4 || xhr.status != 200
    if options.dataType == 'json'
      response = JSON.parse xhr.responseText
    else
      response = xhr.responseText
    options.success.call xhr, response
  xhr.send toQueryString(options.data)

@get = (options)->
  options.method = 'GET'
  ajax options

  "get'n"

@post = (options)->
  options.method = 'POST'
  ajax options

  "post'n"

@$ = (query)->
  document.querySelectorAll query

each = (arr, func)->
  for item in arr
    func item

filter = (arr, func)->
  output = []
  each arr, (item)->
    output.push(item) if func(item)

  output

where = (arr, attrs)->
  filter arr, (item)->
    for key of attrs
      return false if attrs[key] != item[key]
    true

random = (arr)->
  arr[Math.floor(Math.random() * arr.length)]

@_ =
  each: each
  filter: filter
  where: where
  random: random

rootURL = 'http://totalrecall.99cluster.com'

toQueryString = (json)->
  url = []
  for key, value of json
    url.push "#{encodeURIComponent(key)}=#{encodeURIComponent(value)}"

  url.join '&'

ajax = (options)->
  options.data ||= {}
  options.success ||= ->
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

@post = (options)->
  options.method = 'POST'
  ajax options

@Game =
  init: ->
    Game.create
      name: 'bruce'
      email: 'brucelee@gmail.com'
    , Game.start

  start: (data)->
    Game.id = data.id
    Game.width = data.width
    Game.height = data.height
    for x in [0...Game.width] by 1
      for y in [0...Game.height] by 1
        Game.choose x, y

  create: (data, callback)->
  	post
      url: '/games/'
      dataType: 'json'
      data: data
      success: callback

  choose: (x, y)->
    get
      url: "/games/#{Game.id}/cards/#{x},#{y}"
      success: (letter)->
        console.log "#{x},#{y} = #{letter}"

  end: (x1, y1, x2, y2)->
    post
      url: "/games/#{Game.id}/end"
      dataType: 'json'
      data:
        x1: x1
        y1: y1
        x2: x2
        y2: y2
      success: (data)->
        console.log data

@Game =
  cards: []
  init: ->
    Game.create
      name: 'bruce'
      email: 'brucelee@gmail.com'
    , Game.setup

  setup: (data)->
    Game.id = data.id
    Game.width = data.width
    Game.height = data.height

    $('#board')[0].innerHTML = JST['templates/board'](data)

    for y in [0...Game.height] by 1
      for x in [0...Game.width] by 1
        Game.cards.push
          x: x
          y: y
          letter: null
          el: $("#card-#{x}-#{y}")[0]
          front: $("#card-#{x}-#{y}-front")[0]

    Game.nextTurn()

  nextTurn: ->
    setTimeout ->
      Game.turn()
    , 1000

  turn: ->
    Game.flipUnmatched()

    if Game.cards.length == 2
      Game.end()
    else
      Game.chooseRandom (card1)->
        previous = Game.previousCardWithLetter card1.letter
        if previous
          Game.choose previous, (card2)->
            Game.match [card1, card2]
        else
          Game.chooseRandom (card2)->
            previous = Game.previousCardWithLetter card2.letter
            if previous
              Game.chooseMatch previous, card2
            else
              Game.nextTurn()

  chooseRandom: (callback)->
    cards = _.filter Game.cards, (card)->
      card != Game.lastRandom && card.letter == null
    unknownCard = _.random cards
    Game.lastRandom = unknownCard
    Game.choose unknownCard, (card)->
      callback card

  previousCardWithLetter: (letter)->
    cards = _.filter Game.cards, (card)->
      card != Game.lastRandom
    matches = _.where cards, letter: letter
    if matches.length == 0
      false
    else
      matches[0]

  chooseMatch: (card1, card2)->
    Game.flipUnmatched()
    Game.choose card1, ->
      Game.choose card2, ->
        Game.match [card1, card2]

  flipUnmatched: ->
    _.each $('.unmatched.flip'), (el)->
      el.classList.remove 'flip'

  match: (cards)->
    _.each cards, (card)->
      card.el.classList.add 'match'
      Game.cards.splice(Game.cards.indexOf(card), 1)
    Game.nextTurn()

  create: (data, callback)->
  	post
      url: '/games/'
      dataType: 'json'
      data: data
      success: callback

  choose: (card, callback)->
    get
      url: "/games/#{Game.id}/cards/#{card.x},#{card.y}"
      success: (letter)->
        card.letter = letter
        card.front.innerHTML = letter
        card.el.classList.add 'flip'

        callback card

  end: ->
    post
      url: "/games/#{Game.id}/end"
      dataType: 'json'
      data:
        x1: Game.cards[0].x
        y1: Game.cards[0].y
        x2: Game.cards[1].x
        y2: Game.cards[1].y
      success: (data)->
        $('#message')[0].innerHTML = data.message
        $('body')[0].classList.add 'game-over'

        setTimeout ->
          window.location.href = 'http://www.youtube.com/watch?v=KFkRkB568FA'
        , 2000


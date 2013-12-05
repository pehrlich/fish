app.factory "LeapService", [ ->
  console.log "connecting"
  controller = new Leap.Controller()

  controller.on "connect", ->
    console.log "Successfully connected."

# this goes constantly :-/
#  controller.on 'deviceConnected', ->
#    console.log("A Leap device has been connected.")

  controller.on "deviceDisconnected", ->
    console.log "A Leap device has been disconnected."

  previousValidHandIds = []
  controller.on "frame", ->
    newValidHandIds = controller.lastValidFrame.hands.map (hand)-> hand.id

    for id in previousValidHandIds
      unless newValidHandIds.includes(id)
        previousValidHandIds.remove(id)
        controller.emit('lostHand', id)

    for id in newValidHandIds
      unless previousValidHandIds.includes(id)
        previousValidHandIds.push(id)
        controller.emit('foundHand', id)


  # allow hand to engage
  # not sure yet if hand objects are preserved between frames
  engagedHandId = undefined
  controller.addStep (frame)->
    if !engagedHandId
      for hand in frame.hands
        if hand.pointables.length > 1
          console.log 'engaging hand', hand.id
          engagedHandId = hand.id
          controller.emit('engage', hand)

    if engagedHandId
      frame.activeHand = frame.hands.getById(engagedHandId)

      # note sure why activeHand comes back as undefined sometimes
      # it appears that we have an engagedHandId but an empty hand array
      if !frame.activeHand || frame.activeHand.pointables < 1
        console.log 'disengaging hand', engagedHandId
        engagedHandId = undefined
        controller.emit('disengage', frame.activeHand)
        frame.activeHand = undefined

    frame


  # allow hand to tilt
  # ideal api would be
#  controller.addStep ()->
#    zeroAngle = 0
#    @config = (options) ->
#      zeroAngle = options.zeroAngle unless (options.zeroAngle == undefined)
#    return (frame) ->


  window.PitchHandler = ->
    zeroAngle = 0
    activationAngle = 0.5 #radians
    state = undefined

    @setZeroAngle = (angle)->
      zeroAngle = angle

#    Hand.prototype.adjustedPitch = ->
#      @pitch() - zeroAngle

  zeroAngle = 0.4
  activationAngle = 0.4 #radians
  state = undefined

  Leap.Hand.prototype.adjustedPitch = ->
    @pitch() - zeroAngle

  window.PitchHandler.prototype.onFrame = (frame) ->
    if frame.activeHand
      if state != 'noseDown' && frame.activeHand.adjustedPitch() < -activationAngle
        state = 'noseDown'
        controller.emit('noseDown')

      else if state != 'noseUp' && frame.activeHand.adjustedPitch() > activationAngle
        state = 'noseUp'
        controller.emit('noseUp')

      else if state != 'noseSteady' && Math.abs(frame.activeHand.adjustedPitch()) < activationAngle
        state = 'noseSteady'
        controller.emit('noseSteady')

    frame

  controller.addStep window.PitchHandler.prototype.onFrame


  speedFactor = 5
  balanceFactor = 1

  # target time per side for autoFlap
  controller.addStep (frame)->
    if frame.activeHand
      # negative z is towards the screen
      # returns a ms numer based on hand position
      # move 10 cm towards the screen to get infinitely fast flapping
      # heh.
      frame.baseFlapTime = 600 + (speedFactor * frame.activeHand.palmPosition[2]) # todo: make this api available

      # todo: check the signage
      frame.leftFlapTime = frame.baseFlapTime + (balanceFactor * frame.activeHand.palmPosition[0])
      frame.rightFlapTime = frame.baseFlapTime - (balanceFactor * frame.activeHand.palmPosition[0])

    frame




  controller.connect()
  controller
]
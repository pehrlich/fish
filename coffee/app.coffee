# the idea:
# send pulses every 20ms
# Z-dimension: Duration on side
# X-Dimension: Balance between sides
# Sound: play side-specific tone when sending message
# Hand AoA controls the fish tilt
# software initializes when taking hand out of fist somewhere above leap
# todo: Make coordinate system relative to wrist!


window.app = angular.module("Fish", [])

app.controller "FishController", ["$scope", "LeapService", "FishService", ($scope, LeapService, FishService) ->
  $scope.base_pose = {}
  $scope.paused = true
  $scope.tilt = 0
  $scope.activeHandId = undefined;

  # these events get enqueued no matter what
  LeapService.on 'noseUp', ->
    FishService.enqueue('stop')
    $scope.noseState = 'noseUp'

  LeapService.on 'noseDown', ->
    FishService.enqueue('stop')
    $scope.noseState = 'noseDown'

  LeapService.on 'noseSteady', ->
    FishService.enqueue('stop')
    $scope.noseState = 'noseSteady'


  $scope.intializeFromCurrentPose = ->
    console.log 'would initalize now'
    $scope.base_pose = {
#      tilt
    }

  LeapService.on 'engage', (hand)->
    $scope.intializeFromCurrentPose(hand)
    FishService.queue = []
    FishService.start()

  LeapService.on 'disengage', ->
    FishService.stop()


  lastFlapTime = new Date()
  lastFlapDirection = 'Right' # always flap left first

  $scope.autoFlap = (frame)->
    elapsedTime = new Date() - lastFlapTime
    console.log 'autoflap'
    if lastFlapDirection == 'Right' && elapsedTime > frame.rightFlapTime
      $scope.flap('Left')

    else if lastFlapDirection == 'Left' && elapsedTime > frame.leftFlapTime
      $scope.flap('Right')


  $scope.flap = (direction)->
    console.log 'flap', direction
    FishService.enqueue('stop')
    FishService.enqueue("flap#{direction}")
    lastFlapDirection = direction
    lastFlapTime = new Date()


  lastCommandTime = new Date()
  $scope.autoNose = ->
    # prevent flooding.  Without this, movement will be jerkey.
    # this probably belongs in Fish Service.
    elapsedTime = new Date() - lastCommandTime
    if elapsedTime > 200
      FishService.enqueue $scope.noseState
      lastCommandTime = new Date()

  LeapService.on 'frame', (frame) ->
    return unless FishService.going

    # todo: experiment with == 0 or < 2 here.
    if $scope.noseState == 'noseSteady'
      $scope.autoFlap(frame)
    else
      $scope.autoNose(frame)

    $scope.history = FishService.history
    $scope.frame = frame
    $scope.$digest()

]

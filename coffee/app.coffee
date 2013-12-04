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
  $scope.activeHandId = undefiend;

  # these events get enqueued no matter what
  LeapService.on 'noseUp', ->
    FishService.enqueue('noseUp')

  LeapService.on 'noseDown', ->
    FishService.enqueue('noseDown')

  LeapService.on 'noseSteady', ->
    FishService.enqueue('noseSteady')


  $scope.intializeFromCurrentPose = ->
    console.log 'would initalize now'
    $scope.base_pose = {
#      tilt
    }

  LeapController.on 'engage', (hand)->
    $scope.intializeFromCurrentPose(hand)
    FishService.clearQueue()
    FishService.start()

  LeapController.on 'disengage', ->
    FishService.stop()


  lastFlapTime = undefiend
  lastFlapDirection = undefiend
  $scope.autoFlap = (frame)->
    elapsedTime = new Date() - lastFlapTime
    if lastFlapDirection == 'right' && elapsedTime > frame.rightFlapTime
      FishService.enqueue('flapLeft')
      lastFlapDirection == 'left'
      lastFlapTime = new Date()

    if lastFlapDirection == 'left' && elapsedTime > frame.leftFlapTime
      FishService.enqueue('flapRight')
      lastFlapDirection == 'right'
      lastFlapTime = new Date()



  Leap.on 'frame', (frame) ->
    return unless FishService.going

    # todo: experiment with == 0 or < 2 here.
    if FishService.queue.length == 0
      $scope.autoFlap(frame)

]

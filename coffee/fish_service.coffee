app.factory 'FishService', [->
  # private methods

  # https://github.com/voodootikigod/node-serialport
  SerialPort = require("serialport").SerialPort
  serialPort = new SerialPort("/dev/tty.usbmodem12341", {
    baudrate: 57600
  });

  serialPort.on 'open', ->
    console.log 'serial port opened', arguments

  queueCommandToSerialCommand = {
    noseUp: 'w',
    noseDown: 's',
    flapLeft: 'd',
    flapRight: 'a'
    stop: 'q'
  }

  go = ->
    if command = fishService.queue.shift()

      unless serialCommand = queueCommandToSerialCommand[command]
        console.warn "Unknown Command: ", command
        return

#      console.log 'sending to serial port', command
      serialPort.write "#{serialCommand}\r\t", (err, results) ->
#        console.log 'done writing', err, results
    else
#      console.log 'empty queue, sending nothing'

    # we have a command timing of 20ms, so here we send a command every 40 just for safety. Nah j/k, we're waiting
    # for after the execution anyway
    if fishService.going
      setTimeout go, 20



  # public methods
  fishService = {
    going: false,
    queue: []
    history: []
    start: ->
      fishService.going = true
      go()

    stop: ->
      fishService.queue = []
      fishService.enqueue('stop')
      fishService.going = false

    enqueue: (command)->
      fishService.queue.push command
      fishService.history.unshift command
#      console.log command, 'enqueued'
  }
  return fishService
]

app.factory 'FishService', [->
  # private methods

  # https://github.com/voodootikigod/node-serialport
  SerialPort = require("serialport").SerialPort
  serialPort = new SerialPort("/dev/tty-usbserial1", {
    # 9600. Must be one of: 115200, 57600, 38400, 19200, 9600, 4800, 2400, 1800, 1200, 600, 300, 200, 150, 134, 110, 75, or 50.
    # baudrate: 57600
  });

  serialPort.on 'open', ->
    console.log 'serial port opened', arguments

  queueCommandToSerialCommand = {
    noseUp: 'w',
    noseDown: 's',
    flapLeft: 'a',
    flapRight: 'd'
    stop: '' # todo: what's the stopflap command?
  }

  go = ->
    if command = fishService.queue.length.pop()

      unless serialCommand = queueCommandToSerialCommand[command]
        console.warn "Unknown Command: ", command
        return

      console.log 'sending to serial port', command
      serialPort.write serialCommand, (err, results) ->
        # console.log 'done writing', err, results

    # we have a command timing of 20ms, so here we send a command every 40 just for safety. Nah j/k, we're waiting
    # for after the execution anyway
    if fishService.going
      setTimeout go, 20



  # public methods
  fishService = {
    going: false,
    queue: []
    start: ->
      fishService.going = true
      go()

    stop: ->
      fishService.queue = []
      fishService.enqueue('stopFlap')
      fishService.enqueue('noseSteady')
      fishService.going = false

    enqueue: (command)->
      queue.push command
      console.log command, 'enqueued'
  }
  return fishService
]

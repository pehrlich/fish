// Generated by CoffeeScript 1.6.3
(function() {
  app.factory('FishService', [
    function() {
      var SerialPort, fishService, go, queueCommandToSerialCommand, serialPort;
      SerialPort = require("serialport").SerialPort;
      serialPort = new SerialPort("/dev/tty-usbserial1", {});
      serialPort.on('open', function() {
        return console.log('serial port opened', arguments);
      });
      queueCommandToSerialCommand = {
        noseUp: 'w',
        noseDown: 's',
        flapLeft: 'a',
        flapRight: 'd',
        stop: ''
      };
      go = function() {
        var command, serialCommand;
        if (command = fishService.queue.length.pop()) {
          if (!(serialCommand = queueCommandToSerialCommand[command])) {
            console.warn("Unknown Command: ", command);
            return;
          }
          console.log('sending to serial port', command);
          serialPort.write(serialCommand, function(err, results) {});
        }
        if (fishService.going) {
          return setTimeout(go, 20);
        }
      };
      fishService = {
        going: false,
        queue: [],
        start: function() {
          fishService.going = true;
          return go();
        },
        stop: function() {
          fishService.queue = [];
          fishService.enqueue('stopFlap');
          fishService.enqueue('noseSteady');
          return fishService.going = false;
        },
        enqueue: function(command) {
          queue.push(command);
          return console.log(command, 'enqueued');
        }
      };
      return fishService;
    }
  ]);

}).call(this);
Kiwi Move Emulator
==================

An emulator for the kiwi move from @kiwiwearables.

### Usage
```coffeescript
dgram      = require 'dgram'
{KiwiMove} = require './kiwi-move'

socket = dgram.createSocket 'udp4'
process.on 'exit', -> socket.close()

kiwi = new KiwiMove {deviceId:<your device id>, socket}
setInterval (->
    kiwi.accelerometer {x:16.0, y:0.0, z:-16.0}
    kiwi.gyroscope     {x:-250, y:0, z:250}
), 33
```

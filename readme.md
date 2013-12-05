## Building

https://github.com/rogerwang/node-webkit/wiki/How-to-package-and-distribute-your-apps

```
  zip -r ../${PWD##*/}.nw *
  open -n -a node-webkit ../fish.nw
  # aka
  zip -r ../${PWD##*/}.nw * && open -n -a node-webkit ../fish.nw
```


https://github.com/rogerwang/node-webkit/wiki/Using-Node-modules#3rd-party-modules-with-cc-addons
For C++ recompiling

```
coffee -w -c -o ../js ./
```


```
open -n -a node-webkit ../fish.nw
```


```
### Balancing & Tuning

```ruby
# controls what pitch is considered "flat"
zeroAngle = 0.4 #radians

# controls what pitch is required to activate a tilt
activationAngle = 0.4 #radians



#leap_service.coffee

# controls how much x palmPosition changes flap speed
speedFactor

# controls how much y palmPosition changes flap left-right ratio
balanceFactor

```

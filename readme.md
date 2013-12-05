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
# monitoring-sdk-ios

## Build Framework for iOS

```
$ make framework
```

This should result in `MonitoringDevice.framework` being generated in `Build`.  
Copy the built framework into your Unity project's `Assets/Plugins/iOS`.  
Enable `Add To Embedded Binaries` in the Unity Inspector of `MonitoringDevice.framework`.

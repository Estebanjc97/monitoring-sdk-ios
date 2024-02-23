import Foundation

@_cdecl("MonitoringDevice_startTracking")
public func MonitoringDevice_startTracking() {
    MonitoringDevice.tracker.startTracking()
}

@_cdecl("MonitoringDevice_stopTracking")
public func MonitoringDevice_stopTracking() {
    MonitoringDevice.tracker.stopTracking()
}

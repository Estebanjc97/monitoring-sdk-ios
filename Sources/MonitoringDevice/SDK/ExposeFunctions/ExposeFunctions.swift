import Foundation

@_cdecl("MonitoringDevice_startTracking")
public func MonitoringDevice_startTracking() {
    MonitoringDevice.tracker.startTracking()
}

@_cdecl("MonitoringDevice_stopTracking")
public func MonitoringDevice_stopTracking(_ handler: @convention(c) (UnsafePointer<CChar>) -> Void) {
    let trackedData = MonitoringDevice.tracker.stopTracking()
    let encoder = JSONEncoder()
    
    do {
        let jsonData = try encoder.encode(trackedData)
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            handler(jsonString)
        }
    } catch {
        handler("Error al serializar datos a JSON")
    }
    
}

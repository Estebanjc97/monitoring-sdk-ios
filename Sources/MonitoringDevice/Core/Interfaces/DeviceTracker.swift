public protocol DeviceTracker {
    func startTracking()
    func stopTracking() -> [monitoringInfo]
}

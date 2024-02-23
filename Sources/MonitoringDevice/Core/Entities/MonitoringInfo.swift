public struct Session {
    public let appName: String
    public let reportName: String
    
    public init(appName: String, reportName: String) {
        self.appName = appName
        self.reportName = reportName
    }
}

public struct monitoringInfo {
    var CPU: Double
    var GPU: Double
    var RAM: UInt64
}

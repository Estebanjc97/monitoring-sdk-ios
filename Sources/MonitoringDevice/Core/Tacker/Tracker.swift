import Foundation
import System
import Metal

public class Tracker: DeviceTracker {
    
    private var timer: Timer?
    private var usageData: [monitoringInfo] = []
    let CPUUsageLock = NSLock()
    
    public init() {}
    
    public func startTracking() {
        print("Start tracking")
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(monitorData), userInfo: nil, repeats: true)
    }
    
    public func stopTracking() -> [monitoringInfo] {
        print("Stop tracking")
        timer?.invalidate()
        timer = nil
        return usageData
    }
    
    @objc private func monitorData() {
        let cpuUsage = recordCPUUsage()
        let gpuUsage = recordGPUUsage()
        let memoryUsage = recordMemoryUsage()
        
        usageData.append(monitoringInfo(CPU: cpuUsage, GPU: gpuUsage, RAM: memoryUsage))
        
        print("This is the usage - CPU \(cpuUsage) - GPU \(gpuUsage) - Memory \(memoryUsage)")
    }
    
    private func recordCPUUsage() -> Double {
        let  HOST_CPU_LOAD_INFO_COUNT = MemoryLayout<host_cpu_load_info>.stride / MemoryLayout<integer_t>.stride

        var size = mach_msg_type_number_t(HOST_CPU_LOAD_INFO_COUNT)
        let hostInfo = host_cpu_load_info_t.allocate(capacity: 1)
        let result = hostInfo.withMemoryRebound(to: integer_t.self, capacity: HOST_CPU_LOAD_INFO_COUNT) {
            host_statistics(mach_host_self(), HOST_CPU_LOAD_INFO, $0, &size)
        }
        if result != KERN_SUCCESS{
            print("Error  - \(#file): \(#function) - kern_result_t = \(result)")
            return 0.0
        }
        let data = hostInfo.move()
        hostInfo.deallocate()
                
        let totalTicks = data.cpu_ticks.0 + data.cpu_ticks.1 + data.cpu_ticks.2
        let usage = Double(data.cpu_ticks.0 + data.cpu_ticks.1) / Double(totalTicks)
        
        return usage * 100.0
    }
    
    private func recordGPUUsage() -> Double {
        let device = MTLCreateSystemDefaultDevice()
        let commandQueue = device?.makeCommandQueue()

        let commandBuffer = commandQueue?.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeComputeCommandEncoder()

        commandEncoder?.endEncoding()
        commandBuffer?.commit()

        commandBuffer?.waitUntilCompleted()

        let gpuUsage = commandBuffer?.gpuEndTime
        
        return gpuUsage ?? 0.0
    }
    
    private func recordMemoryUsage() -> Double {
        var taskInfo = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &taskInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_,
                            task_flavor_t(MACH_TASK_BASIC_INFO),
                            $0,
                            &count)
            }
        }

        guard kerr == KERN_SUCCESS else { return 0.0 }
            
        let usedMemory = Double(taskInfo.resident_size) / (1024 * 1024) // Convert bytes to megabytes
        let physicalMemory = Double(ProcessInfo.processInfo.physicalMemory) / (1024 * 1024) // Convert bytes to megabytes
            
        let memoryUsagePercentage = (usedMemory / physicalMemory) * 100.0
        return memoryUsagePercentage
    }
    
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using MonitoringDevice;

public class InitSDK : MonoBehaviour
{

    void Start()
    {
        SwiftBridge.OnMonitoredData += (string message) =>
        {
            Debug.Log("Puto mira esto -  Message: " + message);
        };
    }

    public void StartTracking()
    {
        #if UNITY_IOS
        SwiftBridge.StartTracking();
        #endif
    }

    public void StopTracking()
    {
        #if UNITY_IOS
        SwiftBridge.StopTracking();
        #endif
    }

}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using MonitoringDevice;
using TMPro;

public class MonitoringDeviceImplementation : MonoBehaviour
{
    [SerializeField] TextMeshProUGUI text;

    void Start()
    {
        SwiftBridge.OnMonitoredData += (string data) =>
        {
            text.text = string.Format("Monitored Data: {0}", data);
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

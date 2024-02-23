using AOT;
using System;
using System.Runtime.InteropServices;
using UnityEngine;

namespace MonitoringDevice
{
    public static class SwiftBridge
    {
        #if UNITY_IOS
            [DllImport("__Internal")]
            private static extern void MonitoringDevice_startTracking();

            [DllImport("__Internal")]
            private static extern void MonitoringDevice_stopTracking([MarshalAs(UnmanagedType.FunctionPtr)] UnityCallback callback);
        #endif

        [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
        private delegate void UnityCallback([MarshalAs(UnmanagedType.LPStr), In] string result);

        public static event Action<string> OnMonitoredData;

        [MonoPInvokeCallback(typeof(UnityCallback))]
        private static void CallbackHandler(string result)
        {
            OnMonitoredData(result);    
        }

        public static void StartTracking()
        {
            MonitoringDevice_startTracking();
        }

        public static void StopTracking()
        {
            MonitoringDevice_stopTracking(CallbackHandler);
        }

    }
}

package com.example.wifi_direct_share

import io.flutter.embedding.engine.FlutterEngine
import android.content.Context
import android.net.wifi.p2p.WifiP2pManager
import android.net.wifi.p2p.WifiP2pManager.Channel
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.android.FlutterActivity

class WifiDirectManager(private val context: Context) {
    private val manager: WifiP2pManager = context.getSystemService(Context.WIFI_P2P_SERVICE) as WifiP2pManager
    private val channel: Channel = manager.initialize(context, context.mainLooper, null)

    fun discoverDevices(result: MethodChannel.Result) {
        manager.discoverPeers(channel, object : WifiP2pManager.ActionListener {
            override fun onSuccess() {
                result.success("Discovery started")
            }

            override fun onFailure(reasonCode: Int) {
                result.error("DISCOVERY_FAILED", "Discovery failed with reason code: $reasonCode", null)
            }
        })
    }

    fun connectToDevice(device: String, result: MethodChannel.Result) {
        // Implementation for connecting to a device
    }

    fun sendMessage(message: String, result: MethodChannel.Result) {
        // Implementation for sending a message
    }
}


class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.wifi_direct_share/wifi"
    private lateinit var wifiDirectManager: WifiDirectManager

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        wifiDirectManager = WifiDirectManager(this)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "discoverDevices" -> wifiDirectManager.discoverDevices(result)
                "connectToDevice" -> wifiDirectManager.connectToDevice(call.argument("device")!!, result)
                "sendMessage" -> wifiDirectManager.sendMessage(call.argument("message")!!, result)
                else -> result.notImplemented()
            }
        }
    }
}
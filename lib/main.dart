import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('WiFi Direct Share'),
        ),
        body: WifiDirectScreen(),
      ),
    );
  }
}

class WifiDirectScreen extends StatefulWidget {
  @override
  _WifiDirectScreenState createState() => _WifiDirectScreenState();
}

class _WifiDirectScreenState extends State<WifiDirectScreen> {
  static const platform = MethodChannel('com.example.wifi_direct_share/wifi');
  String _status = 'Not Connected';

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    // Request location permission which is needed for Wi-Fi operations
    await [
      Permission.location,
    ].request();
  }

  Future<void> _discoverDevices() async {
    try {
      final String result = await platform.invokeMethod('discoverDevices');
      setState(() {
        _status = result;
      });
    } on PlatformException catch (e) {
      setState(() {
        _status = "Failed to discover devices: '${e.message}'";
      });
    }
  }

  Future<void> _connectToDevice(String device) async {
    try {
      final String result = await platform.invokeMethod('connectToDevice', {'device': device});
      setState(() {
        _status = result;
      });
    } on PlatformException catch (e) {
      setState(() {
        _status = "Failed to connect to device: '${e.message}'";
      });
    }
  }

  Future<void> _sendMessage(String message) async {
    try {
      final String result = await platform.invokeMethod('sendMessage', {'message': message});
      setState(() {
        _status = result;
      });
    } on PlatformException catch (e) {
      setState(() {
        _status = "Failed to send message: '${e.message}'";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Status: $_status'),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _discoverDevices,
          child: Text('Discover Devices'),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            _connectToDevice("deviceName"); // Replace with actual device name
          },
          child: Text('Connect to Device'),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            _sendMessage("Hello from Flutter!");
          },
          child: Text('Send Message'),
        ),
      ],
    );
  }
}

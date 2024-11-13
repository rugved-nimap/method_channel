import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  static const platform = MethodChannel('com.example.battery');

  String _batteryLevel = 'Unknown battery level.';
  String _deviceModel = 'Unknown Model.';

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    String deviceModel;

    try {
      final result1 = await platform.invokeMethod<int>('getBatteryLevel');
      batteryLevel = 'Battery level: $result1%';

      final result2 = await platform.invokeMethod<String>('getDeviceModel');
      deviceModel = 'Model: $result2';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
      deviceModel = "Failed to get device model: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
      _deviceModel = deviceModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('METHOD CHANNEL'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _deviceModel,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              _batteryLevel,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getBatteryLevel,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

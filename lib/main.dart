import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'accelerometer_service.dart';
import 'ar_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ContentView(),
    );
  }
}

class ContentView extends StatefulWidget {
  const ContentView({super.key});

  @override
  _ContentViewState createState() => _ContentViewState();
}

class _ContentViewState extends State<ContentView> {
  final accelerometerService = AccelerometerService();
  double distance = 0;

  @override
  void initState() {
    super.initState();
    accelerometerService.startListening();
  }

  @override
  void dispose() {
    accelerometerService.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ARKitImageRecognitionPage( onDistanceChange: (distance){
            setState(() {
              this.distance = distance;
            });
           },),
          Container(
            width: 200,
            color: distance >= 10
                ? const Color.fromARGB(136, 115, 241, 77)
                : const Color.fromARGB(135, 241, 77, 77),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Distance:",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Text("${distance.toStringAsFixed(2)} meters",
                          style: const TextStyle(fontSize: 24)),
                      const SizedBox(height: 20),
                      const Text("Acceleration:",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ValueListenableBuilder<AccelerometerEvent>(
                  valueListenable: accelerometerService.accelerometer,
                  builder: (context, event, _) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("x: ${event.x.toStringAsFixed(2)}",
                          style: const TextStyle(fontSize: 24)),
                      Text("y: ${event.y.toStringAsFixed(2)}",
                          style: const TextStyle(fontSize: 24)),
                      Text("z: ${event.z.toStringAsFixed(2)}",
                          style: const TextStyle(fontSize: 24)),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                ValueListenableBuilder<bool>(
                  valueListenable: accelerometerService.isLandscape,
                  builder: (context, isLandscape, _) => Text(
                    isLandscape ? "Landscape Mode" : "Portrait Mode",
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

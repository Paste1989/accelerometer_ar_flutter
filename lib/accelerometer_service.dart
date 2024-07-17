import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';

class AccelerometerService {
  final ValueNotifier<AccelerometerEvent> _accelerometer = ValueNotifier<AccelerometerEvent>(AccelerometerEvent(0, 0, 0));
  final ValueNotifier<bool> _isLandscape = ValueNotifier<bool>(false);

  ValueNotifier<AccelerometerEvent> get accelerometer => _accelerometer;
  ValueNotifier<bool> get isLandscape => _isLandscape;

  void startListening() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      _accelerometer.value = event;
      _isLandscape.value = event.x.abs() > event.y.abs();
    });
  }

  void stopListening() {
    // No need to explicitly stop listening as the stream will close automatically.
  }
}

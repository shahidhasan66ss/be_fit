import 'package:flutter/material.dart';
import 'package:heart_bpm/chart.dart';
import 'package:heart_bpm/heart_bpm.dart';

class HeartRateContainer extends StatefulWidget {
  @override
  _HeartRateContainerState createState() => _HeartRateContainerState();
}

class _HeartRateContainerState extends State<HeartRateContainer> {

  List<SensorValue> data = [];
  List<SensorValue> bpmValues = [];

  bool isBPMEnabled = false;
  int measuredBPM = 0; // Variable to store measured BPM
  String healthCondition = ''; // Variable to store health condition text

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Heart Image with Text
        GestureDetector(
          onTap: () {
            setState(() {
              isBPMEnabled = !isBPMEnabled;
              if (!isBPMEnabled) {
                measuredBPM = 0; // Reset measured BPM when stopping
                healthCondition = ''; // Reset health condition text
              }
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                'assets/images/home/heart.png', // Replace with your heart image path
                height: 100,
                width: 100,
              ),
              Positioned(
                top: 60, // Adjust this value to move the text down
                child: Text(
                  isBPMEnabled ? 'Measuring...' : 'Tap to Measure BPM',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 6,
                  ),
                ),
              ),
              if (measuredBPM > 0) // Display BPM rate after measurement
                Positioned(
                  bottom: 20, // Adjust this value to move the circle point up
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red, // Color of the circle point
                        ),
                        child: Center(
                          child: Text(
                            measuredBPM.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        healthCondition,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        // HeartBPMDialog Widget
        if (isBPMEnabled)
          HeartBPMDialog(
            context: context,
            showTextValues: true,
            borderRadius: 10,
            onRawData: (value) {
              setState(() {
                if (data.length >= 100) data.removeAt(0);
                data.add(value);
              });
            },
            onBPM: (value) {
              setState(() {
                if (bpmValues.length >= 100) bpmValues.removeAt(0);
                bpmValues.add(
                  SensorValue(value: value.toDouble(), time: DateTime.now()),
                );
                measuredBPM = value.toInt(); // Store measured BPM
                updateHealthCondition(value.toInt()); // Update health condition based on BPM
              });
            },
          ),
      ],
    );
  }

  void updateHealthCondition(int bpm) {
    if (bpm < 60) {
      setState(() {
        healthCondition = 'Low heart rate (Bradycardia)';
      });
    } else if (bpm >= 60 && bpm <= 100) {
      setState(() {
        healthCondition = 'Normal heart rate';
      });
    } else {
      setState(() {
        healthCondition = 'High heart rate (Tachycardia)';
      });
    }
  }
}

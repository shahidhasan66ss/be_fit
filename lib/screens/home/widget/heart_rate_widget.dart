import 'package:flutter/material.dart';
import 'package:heart_bpm/chart.dart';
import 'package:heart_bpm/heart_bpm.dart';

import '../../../core/const/color_constants.dart';
import '../../../core/const/path_constants.dart';
import '../../../core/const/text_constants.dart';

class HeartRateCard extends StatefulWidget {
  @override
  _HeartRateCardState createState() => _HeartRateCardState();
}

class _HeartRateCardState extends State<HeartRateCard> {
  List<SensorValue> data = [];
  List<SensorValue> bpmValues = [];
  bool isBPMEnabled = false;
  int measuredBPM = 0; // Variable to store measured BPM
  String healthCondition = ''; // Variable to store health condition text

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // First Row: Completed Workouts
          _createBPMwidget(context),
          SizedBox(height: 20), // Adjust spacing between rows
        ],
      ),
    );
  }

  Widget _createBPMwidget(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ColorConstants.white,
        boxShadow: [
          BoxShadow(
            color: ColorConstants.textBlack.withOpacity(0.12),
            blurRadius: 5.0,
            spreadRadius: 1.1,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              if (healthCondition.isNotEmpty) // Display health condition if available
                Expanded(
                  child: Text(
                    healthCondition,
                    style: TextStyle(
                      color: ColorConstants.textBlack,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
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
                if (measuredBPM > 0) // Display BPM rate after measurement
                  Text(
                    measuredBPM.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 10), // Add some spacing between the image and the text
          Text(
            isBPMEnabled ? 'Measuring...' : 'Tap heart to Measure BPM',
            style: TextStyle(
              color: Colors.black, // Changed to black for visibility
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
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
      ),
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

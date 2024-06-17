import 'package:be_fit/screens/workout_details_screen/widget/panel/workout_details_panel.dart';
import 'package:be_fit/screens/workout_details_screen/widget/workout_details_body.dart';

import 'package:flutter/material.dart';
import 'package:sliding_up_panel2/sliding_up_panel2.dart';

import '../../../core/const/color_constants.dart';
import '../../../core/data/workout_data.dart';

class WorkoutDetailsContent extends StatelessWidget {
  final WorkoutData workout;

  const WorkoutDetailsContent({required this.workout});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: ColorConstants.white,
      child: _createSlidingUpPanel(context),
    );
  }

  Widget _createSlidingUpPanel(BuildContext context) {
    return SlidingUpPanel(
      panelBuilder: () => WorkoutDetailsPanel(workout: workout),
      body: WorkoutDetailsBody(workout: workout),
      minHeight: MediaQuery.of(context).size.height * 0.65,
      maxHeight: MediaQuery.of(context).size.height * 0.87,
      isDraggable: true,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(50),
        topRight: Radius.circular(50),
      ),
    );
  }
}
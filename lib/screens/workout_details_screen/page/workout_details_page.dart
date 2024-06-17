import 'package:be_fit/core/extensions/list_extension.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../core/const/text_constants.dart';
import '../../../core/data/exercise_data.dart';
import '../../../core/data/workout_data.dart';
import '../../common_widgets/fitness_button.dart';
import '../../start_workout/page/start_workout_page.dart';
import '../bloc/workoutdetails_bloc.dart';
import '../widget/workout_details_content.dart';

class WorkoutDetailsPage extends StatelessWidget {
  final WorkoutData workout;
  WorkoutDetailsPage({required this.workout});

  @override
  Widget build(BuildContext context) {
    return _buildContext(context);
  }

  BlocProvider<WorkoutDetailsBloc> _buildContext(BuildContext context) {
    return BlocProvider<WorkoutDetailsBloc>(
      create: (context) => WorkoutDetailsBloc(workout: workout),
      child: BlocConsumer<WorkoutDetailsBloc, WorkoutDetailsState>(
        buildWhen: (_, currState) => currState is WorkoutDetailsInitial,
        builder: (context, state) {
          return Scaffold(
              floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
              floatingActionButton: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: FitnessButton(
                  title: TextConstants.start,
                  onTap: () {
                    ExerciseData? exercise = workout.exerciseDataList.firstWhereOrNull((element) => element.progress < 1);
                    if (exercise == null) exercise = workout.exerciseDataList.first;
                    int exerciseIndex = workout.exerciseDataList.indexOf(exercise);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: BlocProvider.of<WorkoutDetailsBloc>(context),
                            child: StartWorkoutPage(
                              exercise: exercise!,
                              currentExercise: exercise,
                              nextExercise: exerciseIndex + 1 < workout.exerciseDataList.length ? workout.exerciseDataList[exerciseIndex + 1] : null,
                            ),
                          )),
                    );
                  },
                ),
              ),
              body: WorkoutDetailsContent(workout: workout));
        },
        listenWhen: (_, currState) => currState is BackTappedState || currState is WorkoutExerciseCellTappedState,
        listener: (context, state) {
          if (state is BackTappedState) {
            Navigator.pop(context);
          } else if (state is WorkoutExerciseCellTappedState) {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: BlocProvider.of<WorkoutDetailsBloc>(context),
                    child: StartWorkoutPage(
                      exercise: state.currentExercise,
                      currentExercise: state.currentExercise,
                      nextExercise: state.nextExercise,
                    ),
                  )),
            );
          }
        },
      ),
    );
  }
}
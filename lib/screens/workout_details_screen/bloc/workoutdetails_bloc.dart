import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../core/data/exercise_data.dart';
import '../../../core/data/workout_data.dart';

part 'workoutdetails_event.dart';
part 'workoutdetails_state.dart';

class WorkoutDetailsBloc extends Bloc<WorkoutDetailsEvent, WorkoutDetailsState> {
  final WorkoutData workout;
  WorkoutDetailsBloc({required this.workout}) : super(WorkoutDetailsInitial());

  @override
  Stream<WorkoutDetailsState> mapEventToState(
      WorkoutDetailsEvent event,
      ) async* {
    if (event is BackTappedEvent) {
      yield BackTappedState();
    } else if (event is WorkoutExerciseCellTappedEvent) {
      yield WorkoutExerciseCellTappedState(
        currentExercise: event.currentExercise,
        nextExercise: event.nextExercise,
      );
    }
  }
}
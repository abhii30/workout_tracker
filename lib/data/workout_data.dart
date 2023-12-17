import 'package:flutter/material.dart';
import '../models/exercise.dart';
import '../models/workout.dart';

class WorkoutData extends ChangeNotifier {
  /*
  Workout data structure

  - contains different workout
  - each has a name and list of exercises

  */

  List<Workout> workoutList = [
    //default workout
    Workout(
      name: "Upper Body",
      exercises: [
        Exercise(
          name: "Bicep Curls",
          sets: "3",
          reps: "10",
          weight: "130",
        ),
        Exercise(
          name: "Push-ups",
          sets: "3",
          reps: "15",
          weight: "30",
        ),
      ],
    ),
    Workout(
      name: "Lower Body",
      exercises: [
        Exercise(
          name: "Squats",
          sets: " 4",
          reps: "12",
          weight: "150",
        ),
        Exercise(
          name: "Deadlifts",
          sets: "3",
          reps: "10",
          weight: "180",
        ),
      ],
    )
  ];

// checkoff exercsise
  void checkOffExercise(String workoutName, String exerciseName) {
    Exercise relevantExercise = getRelevantExercise(workoutName, exerciseName);

    relevantExercise.isCompleted = !relevantExercise.isCompleted;

    notifyListeners();
  }

//get length of workout list
  int getWorkoutListLength(String workoutName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    return relevantWorkout.exercises.length;
  }

//number of exercises in a workout
  int getNumberOfExercises(String workoutName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    return relevantWorkout.exercises.length;
  }

//get the list data
  List<Workout> getWorkoutList() {
    return workoutList;
  }

// add a workout
  void addWorkout(String name) {
    workoutList.add(Workout(name: name, exercises: []));

    notifyListeners();
  }

  //delete a workout
  void removeWorkout(String name) {
    workoutList.removeWhere((workout) => workout.name == name);

    notifyListeners();
  }

// add an exercise to a workout
  void addExercise(String workoutName, String exerciseName, String sets,
      String reps, String weight) {
    //find the workout
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    //add the exercise
    relevantWorkout.exercises.add(
        Exercise(name: exerciseName, sets: sets, reps: reps, weight: weight));

    notifyListeners();
  }

  //return relevant workout
  Workout getRelevantWorkout(String workoutName) {
    return workoutList.firstWhere((workout) => workout.name == workoutName);
  }

  //return relevant exercise
  Exercise getRelevantExercise(String workoutName, String exerciseName) {
    // find relevant workout
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    // find relevant exercise
    Exercise relevantExercise = relevantWorkout.exercises
        .firstWhere((exercise) => exercise.name == exerciseName);

    return relevantExercise;
  }
}

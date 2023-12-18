import 'package:hive_flutter/hive_flutter.dart';
import 'package:workout_tracker/datetime/date_time.dart';

import '../models/exercise.dart';
import '../models/workout.dart';

class HiveDatabase {
// reference to hive box
  final _myBox = Hive.box("workout_database");

// check if data is already stored
// if not, record the start date
  bool previousDataExists() {
    if (_myBox.isEmpty) {
      print("previous data does not exist");
      _myBox.put("START_DATE", todayDate());
      return false;
    } else {
      print("previous data exists");
      return true;
    }
  }

// return start date as ddmmyyyy
  String getStartDate() {
    return _myBox.get("START_DATE");
  }

// write data
  void saveToDatabase(List<Workout> workouts) {
    final workoutList = convertObjectToWorkoutList(workouts);
    final exerciseList = convertObjectToExerciseList(workouts);

    if (exerciseCompleted(workouts)) {
      _myBox.put("COMPLETION_STATUS_${todayDate()}", 1);
    } else {
      _myBox.put("COMPLETION_STATUS_${todayDate()}", 0);
    }
    // "COMPLETION_STATUS_18122023"

    //save into hive
    _myBox.put("WORKOUTS", workoutList);
    _myBox.put("EXERCISES", exerciseList);
  }

// read data, and return the list of workout
  List<Workout> readFromDatabase() {
    List<Workout> mySavedWorkouts = [];

    List<String> workoutNames = _myBox.get("WORKOUTS");
    final exerciseDetails = _myBox.get("EXERCISES");

    //create workout objects
    for (int i = 0; i < workoutNames.length; i++) {
      //  each workout can have multiple exercises
      List<Exercise> exerciseInEachWorkout = [];
      for (int j = 0; j < exerciseDetails[i].length; j++) {
        //  so add each exercise to the list
        exerciseInEachWorkout.add(Exercise(
            name: exerciseDetails[i][j][0],
            weight: exerciseDetails[i][j][1],
            sets: exerciseDetails[i][j][2],
            reps: exerciseDetails[i][j][3],
            isCompleted: exerciseDetails[i][j][4] == "true" ? true : false));
      }

      //  create indivisual workout
      Workout workout =
          Workout(name: workoutNames[i], exercises: exerciseInEachWorkout);

      //  add indivisual workout to the list
      mySavedWorkouts.add(workout);
    }
    return mySavedWorkouts;
  }

// check if any exercises have been done
  bool exerciseCompleted(List<Workout> workouts) {
    // go to each workout
    for (var workout in workouts) {
      // go to each exercise
      for (var exercise in workout.exercises) {
        // check if exercise is completed
        if (exercise.isCompleted) {
          return true;
        }
      }
    }
    return false;
  }
}

//convert workout objects into a list eg -> [upperbody, lowerbody]
List<String> convertObjectToWorkoutList(List<Workout> workouts) {
  List<String> workoutList = [];
  for (int i = 0; i < workouts.length; i++) {
    workoutList.add(workouts[i].name);
  }
  return workoutList;
}

//converts the exercises in a workout object into a list of strings
List<List<List<String>>> convertObjectToExerciseList(List<Workout> workouts) {
  List<List<List<String>>> exerciseList = [
/*
  [
    Upper Body
    [{biceps , 10 kg, 3 sets, 10 reps},{triceps, 20kg, 4 sets, 12 reps}],

    Lwer body
    [[],[]],
  ]
  ]
  */
  ];
  //go through each workout
  for (int i = 0; i < workouts.length; i++) {
    //  add exercises from each workout
    List<Exercise> exercisesInWorkout = workouts[i].exercises;
    List<List<String>> indivisualWorkout = [
      //  Upper body
      //  [[biceps,10kg,3sets,12reps],[triceps,20kg,4sets,12reps]]
    ];

    //go through each exercise in exerciseList
    for (int j = 0; j < exercisesInWorkout.length; j++) {
      List<String> indivisualExercise = [
        //  [biceps,10kg,3sets,12reps]
      ];
      indivisualExercise.addAll(
        [
          exercisesInWorkout[j].name,
          exercisesInWorkout[j].weight,
          exercisesInWorkout[j].sets,
          exercisesInWorkout[j].reps,
          exercisesInWorkout[j].isCompleted.toString(),
        ],
      );
      indivisualWorkout.add(indivisualExercise);
    }
    exerciseList.add(indivisualWorkout);
  }

  return exerciseList;
}

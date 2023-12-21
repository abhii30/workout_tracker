import 'package:flutter/material.dart';
import 'package:workout_tracker/data/hive_database.dart';
import 'package:workout_tracker/datetime/date_time.dart';
import '../models/exercise.dart';
import '../models/workout.dart';

class WorkoutData extends ChangeNotifier {
  final db = HiveDatabase();
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
    // load heat map
    // loadHeatMap();
  }

  // if there are workouts already in db, then get the workout list
  void initializeWorkoutList() {
    if (db.previousDataExists()) {
      workoutList = db.readFromDatabase();
      // otherwise use default list
    } else {
      db.saveToDatabase(workoutList);
    }

    //load heat map
    // loadHeatMap();
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
    //save to database
    db.saveToDatabase(workoutList);
  }

  //delete a workout
  void removeWorkout(String name) {
    workoutList.removeWhere((workout) => workout.name == name);

    notifyListeners();
    //save to database
    db.saveToDatabase(workoutList);
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

  // get start date
  String getStartDate() {
    return db.getStartDate();
  }

  Map<DateTime, int> heatGapDataSet = {};
  void loadHeatMap() {
    DateTime startDate = createDateObject(getStartDate());
    // count the number of days to load
    int daysInBetween = DateTime.now().difference(startDate).inDays;

    for (int i = 0; i < daysInBetween + 1; i++) {
      String ddmmyyyy = createDateString(startDate.add(Duration(days: i)));

      // completion status 0 or 1
      int completionStatus = db.getCompletionStatus(ddmmyyyy);
      // day
      int day = startDate.add(Duration(days: i)).day;
      //month
      int month = startDate.add(Duration(days: i)).month;
      //year
      int year = startDate.add(Duration(days: i)).year;

      final percentForEachDay = <DateTime, int>{
        DateTime(day, month, year): completionStatus
      };

      // add to heat map dataset
      heatGapDataSet.addEntries(percentForEachDay.entries);
    }
  }
}

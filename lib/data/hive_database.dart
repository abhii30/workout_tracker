import '../models/exercise.dart';
import '../models/workout.dart';

class HiveDatabase {
// reference to hive box

// check if data is already stored
// if not, record the start date

// return start date as ddmmyyyy

// write data

// read data, and return the list of workout

// check if any exercises have been done

// return completion status of a given ddmmyyyy
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

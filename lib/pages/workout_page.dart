import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/components/exercise_tile.dart';
import 'package:workout_tracker/data/workout_data.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;
  const WorkoutPage({super.key, required this.workoutName});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  //checkbox
  void onCheckBoxChange(String workoutName, String exerciseName) {
    Provider.of<WorkoutData>(context, listen: false)
        .checkOffExercise(workoutName, exerciseName);
  }

//text firld controller
  final exerciseController = TextEditingController();
  final weightController = TextEditingController();
  final setsController = TextEditingController();
  final repsController = TextEditingController();
  //create new exercise
  void createNewExercise() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Add a new exercise'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // exercise name
                  TextField(
                    decoration: InputDecoration(hintText: 'Exercise Name'),
                    controller: exerciseController,
                  ),
                  //weight
                  TextField(
                    decoration: InputDecoration(hintText: 'Weight'),
                    controller: weightController,
                  ),
                  //sets
                  TextField(
                    decoration: InputDecoration(hintText: 'Sets'),
                    controller: setsController,
                  ),
                  //reps
                  TextField(
                    decoration: InputDecoration(hintText: 'Reps'),
                    controller: repsController,
                  ),
                ],
              ),
              actions: [
                //save
                MaterialButton(
                  onPressed: save,
                  child: const Text('Save'),
                ),

                //cancel
                MaterialButton(
                  onPressed: cancel,
                  child: const Text('Cancel'),
                )
              ],
            ));
  }

  //save workout
  void save() {
    String newExerciseName = exerciseController.text;
    String weight = weightController.text;
    String sets = setsController.text;
    String reps = repsController.text;
    Provider.of<WorkoutData>(context, listen: false)
        .addExercise(widget.workoutName, newExerciseName, weight, reps, sets);
    Navigator.pop(context);
    clear();
  }

  //cancel workout
  void cancel() {
    Navigator.pop(context);
    clear();
  }

  //clear text controller
  void clear() {
    exerciseController.clear();
    weightController.clear();
    setsController.clear();
    repsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
        builder: (context, value, child) => Scaffold(
              appBar: AppBar(title: Text(widget.workoutName)),
              floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () => createNewExercise(),
              ),
              body: ListView.builder(
                  itemCount: value.getNumberOfExercises(widget.workoutName),
                  itemBuilder: (context, index) => ExerciseTile(
                        exerciseName: value
                            .getRelevantWorkout(widget.workoutName)
                            .exercises[index]
                            .name,
                        sets: value
                            .getRelevantWorkout(widget.workoutName)
                            .exercises[index]
                            .sets,
                        reps: value
                            .getRelevantWorkout(widget.workoutName)
                            .exercises[index]
                            .reps,
                        weight: value
                            .getRelevantWorkout(widget.workoutName)
                            .exercises[index]
                            .weight,
                        isCompleted: value
                            .getRelevantWorkout(widget.workoutName)
                            .exercises[index]
                            .isCompleted,
                        onChanged: (val) => onCheckBoxChange(
                            widget.workoutName,
                            value
                                .getRelevantWorkout(widget.workoutName)
                                .exercises[index]
                                .name),
                      )),
            ));
  }
}

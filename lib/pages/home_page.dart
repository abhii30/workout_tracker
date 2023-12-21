import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/components/heat_map.dart';
import 'package:workout_tracker/pages/workout_page.dart';
import '../data/workout_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<WorkoutData>(context, listen: false).initializeWorkoutList();
  }

  //text controller
  final newWorkoutNameController = TextEditingController();

  void createNewWorkout() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: const Text("Create New Workout"),
                content: TextField(
                  decoration: const InputDecoration(hintText: "Workout Name"),
                  controller: newWorkoutNameController,
                ),
                actions: [
                  //save
                  MaterialButton(
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    onPressed: save,
                    child: const Text('Save'),
                  ),

                  //cancel
                  MaterialButton(
                    color: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    onPressed: cancel,
                    child: const Text('Cancel'),
                  )
                ]));
  }

  //save workout
  void save() {
    String newWorkoutName = newWorkoutNameController.text;
    Provider.of<WorkoutData>(context, listen: false).addWorkout(newWorkoutName);
    Navigator.pop(context);
    clearText();
  }

  //cancel workout
  void cancel() {
    Navigator.of(context).pop();
  }

  //clear text controller
  void clearText() {
    newWorkoutNameController.clear();
  }

  //remove a workout
  void removeWorkout(String workoutName) {
    Provider.of<WorkoutData>(context, listen: false).removeWorkout(workoutName);
  }

  //go to workout page
  void goToWorkoutPage(String workoutName) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WorkoutPage(
                  workoutName: workoutName,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (content, value, child) => Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Workout Tracker'),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => createNewWorkout(),
            child: const Icon(Icons.add),
          ),
          body: ListView(
            children: [
              //Heat Map
              // MyHeatMap(
              //     datasets: value.heatGapDataSet,
              //     startDateddmmyyyy: value.getStartDate()),

              //Workout List
              Padding(
                padding: const EdgeInsets.all(8),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: value.getWorkoutList().length,
                  itemBuilder: (context, index) => Card(
                    child: Stack(
                      children: [
                        InkWell(
                          onTap: () => goToWorkoutPage(
                              value.getWorkoutList()[index].name),
                          child: Center(
                            child: Text(value.getWorkoutList()[index].name),
                          ),
                        ),
                        Positioned(
                          top: -10,
                          right: -10,
                          child: IconButton(
                            icon: Icon(Icons.remove_circle_outline),
                            iconSize: 20,
                            color: Colors.red,
                            onPressed: () {
                              value.removeWorkout(
                                  value.getWorkoutList()[index].name);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

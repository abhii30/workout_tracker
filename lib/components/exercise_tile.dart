import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ExerciseTile extends StatelessWidget {
  final String exerciseName;
  final String sets;
  final String reps;
  final String weight;
  final bool isCompleted;
  void Function(bool?)? onChanged;
  ExerciseTile(
      {super.key,
      required this.exerciseName,
      required this.sets,
      required this.reps,
      required this.weight,
      required this.isCompleted,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isCompleted ? const Color(0xFFB8C0FF) : Color(0xFFFFD6FF),
      ),
      child: ListTile(
        title: Text(exerciseName),
        subtitle: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Chip(label: Text("$weight kg")),
          Chip(label: Text("$sets sets")),
          Chip(label: Text("$reps reps")),
        ]),
        trailing: Checkbox(
          value: isCompleted,
          onChanged: (value) => onChanged!(value),
        ),
      ),
    );
  }
}

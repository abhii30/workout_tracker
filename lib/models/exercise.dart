class Exercise {
  final String name;
  final String weight;
  final String reps;
  final String sets;
  bool isCompleted;

  Exercise(
      {required this.name,
      required this.weight,
      required this.sets,
      required this.reps,
      this.isCompleted = false});
}

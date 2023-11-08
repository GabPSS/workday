class Task {
  String? id; //TODO: Maybe don't make this nullable?
  DateTime? createdOn;
  DateTime? due;
  List<String> description = List.empty(growable: true);
  String? assignedTo;
  TaskStatus status = TaskStatus.open;

  Task(
      {this.assignedTo,
      this.createdOn,
      required this.description,
      this.due,
      this.id,
      this.status = TaskStatus.open});

  bool get isAssigned => assignedTo != null;
  bool get isCompleted => status == TaskStatus.done;
}

enum TaskStatus { open, started, pending, done }

import 'package:frontend/models/board/types/DoneDatetime.dart';

class Task {
  final int taskId;
  final String taskTitle;
  late final DoneDatetime taskDoneDatetime;
  final int boardId;
  DateTime? endDatetime;
  DateTime? deadlineDatetime;

  Task(
      {this.taskId = -1,
      required this.taskTitle,
      DoneDatetime? taskDoneDatetime,
      required this.boardId,
      this.endDatetime,
      this.deadlineDatetime}) {
    this.taskDoneDatetime = taskDoneDatetime ?? DoneDatetime();
  }

  Task copyWith({
    String? taskTitle,
    DoneDatetime? taskDoneDatetime,
    int? boardId,
    DateTime? deadlineDatetime,
  }) {
    return Task(
        taskId: this.taskId,
        taskTitle: taskTitle ?? this.taskTitle,
        taskDoneDatetime: taskDoneDatetime ?? this.taskDoneDatetime,
        boardId: boardId ?? this.boardId,
        endDatetime: this.endDatetime,
        deadlineDatetime: deadlineDatetime ?? this.deadlineDatetime);
  }

  @override
  String toString() {
    return 'Task{taskId: $taskId, taskTitle: $taskTitle, taskDoneDatetime: $taskDoneDatetime, endDatetime: $endDatetime, deadlineDatetime: $deadlineDatetime}';
  }

  factory Task.fromMap(Map<String, dynamic> raw) {
    return Task(
      taskId: raw['task_id'],
      taskTitle: raw['task_title'],
      taskDoneDatetime:
           DoneDatetime(DateTime.tryParse(raw['done_datetime'] ?? '')?.toLocal()),
      boardId: raw["board_id"],
      endDatetime: DateTime.tryParse(raw['end_datetime'] ?? '')?.toLocal(),
      deadlineDatetime: DateTime.tryParse(raw['deadline_datetime'] ?? '')?.toLocal()
    );
  }

  static List<Task> fromList(List<dynamic> list) {
    return list.map((e) => Task.fromMap(e)).toList();
  }
}


import '../../models/task/Task.dart';

abstract interface class TaskApi{
  Future<List<Task>> getAllTasks();
  Future updateTask(Task newState);
  Future<List<Task>> getOpenTasks();
  Future<List<Task>> getDoneTasks();
  Future addTask(Task newTask);
  Future removeTask(Task task);
  Future updateTaskOrder(Task task, int index);

  static late TaskApi _impl;

  static void init(TaskApi impl) {
    _impl = impl;
  }

  static TaskApi getInstance() => _impl;
}

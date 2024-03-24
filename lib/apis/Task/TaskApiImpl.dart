
import 'package:logger/logger.dart';

import '../../models/task/Task.dart';
import '../commons/Middleware.dart';
import 'TaskApi.dart';

class TaskApiImpl implements TaskApi {
  final Logger _logger = Logger();

  @override
  Future<List<Task>> getAllTasks() async {
    dynamic result = (await Middleware.getInstance().get_all_tasks());
    return Task.fromList(result);
  }

  @override
  Future updateTask(Task newState) async {
    await Middleware.getInstance().update_task(newState);
  }

  @override
  Future<List<Task>> getDoneTasks() async {
    dynamic result = (await Middleware.getInstance().get_all_tasks());
    _logger.d(result);
    return Task.fromList(result).where((element) => element.taskDoneDatetime.value != null).toList();
  }

  @override
  Future<List<Task>> getOpenTasks() async {
    dynamic result = (await Middleware.getInstance().get_all_tasks());
    _logger.d(result);
    return Task.fromList(result).where((element) => element.taskDoneDatetime.value == null).toList();
  }

  @override
  Future addTask(Task newTask) async {
    return await Middleware.getInstance().addTask(newTask);
  }

  @override
  Future removeTask(Task task) async {
    return await Middleware.getInstance().delete_task(task);
  }

  @override
  Future updateTaskOrder(Task task, int index) async {
    return await Middleware.getInstance().update_task_order(task, index);
  }
}

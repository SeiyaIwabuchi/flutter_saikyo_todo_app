
import '../../models/task/Task.dart';
import '../commons/Middleware.dart';
import 'TaskApi.dart';

class TaskApiImpl implements TaskApi {
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
    dynamic result = (await Middleware.getInstance().get_done_tasks());
    return Task.fromList(result);
  }

  @override
  Future<List<Task>> getOpenTasks() async {
    dynamic result = (await Middleware.getInstance().get_open_tasks());
    return Task.fromList(result);
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

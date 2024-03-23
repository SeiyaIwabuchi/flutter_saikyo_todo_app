import 'dart:convert';

import 'package:frontend/models/board/Board.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/task/Task.dart';

abstract interface class Middleware {
  Future<List<Map<String, dynamic>>> get_all_tasks();
  Future<List<Map<String, dynamic>>> get_done_tasks();
  Future<List<Map<String, dynamic>>> get_open_tasks();

  Future update_task(Task newState);
  Future addTask(Task newTask);
  Future delete_task(Task task);
  Future update_task_order(Task task, int index);

  Future<List<Map<String, dynamic>>> get_all_boards();

  RealtimeChannel subscribeTask(Function(Task) handler);
  RealtimeChannel subscribeBoard(Function(Board) handler);

  static late Middleware _impl;

  static void init(Middleware impl) {
    _impl = impl;
  }

  static Middleware getInstance() {
    return _impl;
  }
}

class MiddlewareSupabase implements Middleware {
  final SupabaseClient client = Supabase.instance.client;

  @override
  get_all_tasks() {
    return client.rpc("get_all_tasks");
  }

  @override
  Future<List<Map<String, dynamic>>> get_done_tasks() {
    return client.rpc("get_done_tasks");
  }

  @override
  Future<List<Map<String, dynamic>>> get_open_tasks() {
    return client.rpc("get_open_tasks");
  }

  @override
  Future update_task(Task newState) {
    Map<String, dynamic> params = {
      "task_id": newState.taskId,
      "task_title": newState.taskTitle,
      "done_datetime": newState.taskDoneDatetime.value?.toIso8601String(),
      "board_id": newState.boardId,
      "deadline_datetime": newState.deadlineDatetime?.toIso8601String(),
    };
    return  client.rpc("update_task", params: {"arg_new_task_history": params});
  }

  @override
  RealtimeChannel subscribeTask(Function(Task) handler) {
    convert(PostgresChangePayload payload) =>
        handler(Task.fromMap(payload.newRecord));

    return client
        .channel("tasks")
        .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: "public",
            table: "task_history",
            callback: convert)
        .subscribe();
  }

  @override
  RealtimeChannel subscribeBoard(Function(Board) handler) {
    convert(PostgresChangePayload payload) =>
        handler(Board.fromMap(payload.newRecord));

    return client
        .channel("boards")
        .onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: "public",
        table: "boards_history",
        callback: convert)
        .subscribe();
  }

  @override
  Future addTask(Task newTask) {
    Map<String, dynamic> params = {
      "task_id": newTask.taskId,
      "task_title": newTask.taskTitle,
      "done_datetime": newTask.taskDoneDatetime.value?.toIso8601String(),
      "board_id": newTask.boardId,
      "deadline_datetime": newTask.deadlineDatetime?.toIso8601String()
    };

    return client.rpc("addTask", params: {"task": params});
  }

  @override
  Future delete_task(Task task) {
    Map<String, dynamic> params = {
      "task_id": task.taskId,
      "task_title": task.taskTitle,
      "done_datetime": task.taskDoneDatetime.value?.toIso8601String(),
      "board_id": task.boardId,
      "deadline_datetime": task.deadlineDatetime
    };

    return client.rpc("delete_task", params: {"delete_task_history": params});
  }

  @override
  Future update_task_order(Task task, int index) {
    Map<String, dynamic> params = {
      "task_id": task.taskId,
      "new_index": index
    };

    return client.rpc("update_task_order", params: {"arg_task_order": params});
  }

  @override
  Future<List<Map<String, dynamic>>> get_all_boards() {
    return client.rpc("get_all_boards");
  }
}

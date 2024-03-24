import 'package:flutter/material.dart';
import 'package:frontend/apis/Task/TaskApi.dart';
import 'package:frontend/apis/board/BoardApi.dart';
import 'package:frontend/apis/commons/Middleware.dart';
import 'package:frontend/flags/FormModeFlags.dart';
import 'package:frontend/models/board/Board.dart';
import 'package:frontend/ui-components/organisms/LoadingDialog.dart';
import 'package:frontend/ui-components/organisms/TaskInputForm.dart';
import 'package:frontend/ui-components/organisms/TaskListWidget.dart';
import 'package:logger/logger.dart';

import '../models/task/Task.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Logger _logger = Logger();

  List<Task> _openTasks = [];
  List<Task> _doneTasks = [];
  late Board _board;

  @override
  void initState() {
    super.initState();
    _fetchTasks();
    Middleware.getInstance().subscribeTask(_updateTaskView);
    Middleware.getInstance().subscribeBoard(_updateBoardView);
  }

  List<Task> sortTask(List<int> sortSrc, List<Task> tasks) {
    final diff = tasks
        .where((task) => !sortSrc.contains(task.taskId))
        .map((e) => e.taskId)
        .toList();
    return (sortSrc + diff)
        .map((e) => tasks.where((element) => element.taskId == e).firstOrNull)
        .whereType<Task>()
        .toList();
  }

  void _fetchTasks() async {
    final List<Task> openTasks = await TaskApi.getInstance().getOpenTasks();
    final List<Task> doneTasks = await TaskApi.getInstance().getDoneTasks();
    final Board board = (await BoardApi.getInstance().getAllBoards()).first;
    final List<Task> sortedOpenTasks =
      sortTask(board.taskOrderList, openTasks);
    final List<Task> sortedCloseTasks =
        sortTask(board.taskOrderList, doneTasks);
    _logger.d(openTasks);
    _logger.d(doneTasks);

    setState(() {
      _openTasks = sortedOpenTasks;
      _doneTasks = sortedCloseTasks;
      _board = board;
    });
  }

  void _updateTask(Task newState) {
    showDialog<void>(context: context, builder: (_) => const LoadingDialog());
    TaskApi.getInstance().updateTask(newState).catchError((err, stacktrace) {
      _logger.e(stacktrace);
      _logger.e(err.toString());
      _showSnackBar(context, "エラーが発生しました。");
    }).whenComplete(() => Navigator.pop(context));
  }

  void _updateTaskOrder(Task target, int newIndex) {
    setState(() {
      //
      if (_openTasks.contains(target)) {
        final int oldIndex = _openTasks.indexOf(target);
        final int _newIndex = oldIndex < newIndex ? newIndex - 1 : newIndex;
        _openTasks.removeAt(oldIndex);
        _openTasks.insert(_newIndex, target);
      } else {
        final int oldIndex = _doneTasks.indexOf(target);
        final int _newIndex = oldIndex < newIndex ? newIndex - 1 : newIndex;
        _doneTasks.removeAt(oldIndex);
        _doneTasks.insert(_newIndex, target);
      }
    });

    showDialog<void>(context: context, builder: (_) => const LoadingDialog());
    TaskApi.getInstance().updateTaskOrder(target, (_openTasks + _doneTasks).indexOf(target)).catchError((err) {
      _logger.e(err.toString());
      _showSnackBar(context, "エラーが発生しました。");
    }).whenComplete(() => Navigator.pop(context));
  }

  void _updateTaskView(Task newState) {
    _openTasks.removeWhere((old) => old.taskId == newState.taskId);
    _doneTasks.removeWhere((old) => old.taskId == newState.taskId);
    if ((newState.endDatetime?.difference(DateTime.now()).inDays ?? 0) <= 0) {
      return;
    }
    if (newState.taskDoneDatetime.value == null) {
      _openTasks.add(newState);
    } else {
      _doneTasks.add(newState);
    }

    final List<Task> sortedOpenTasks =
        sortTask(_board.taskOrderList, _openTasks);
    final List<Task> sortedCloseTasks =
        sortTask(_board.taskOrderList, _doneTasks);

    setState(() {
      _openTasks = sortedOpenTasks;
      _doneTasks = sortedCloseTasks;
    });
  }

  void _updateBoardView(Board board) {
    final List<Task> sortedOpenTasks =
        sortTask(board.taskOrderList, _openTasks);
    final List<Task> sortedCloseTasks =
        sortTask(board.taskOrderList, _doneTasks);

    setState(() {
      _openTasks = sortedOpenTasks;
      _doneTasks = sortedCloseTasks;
      _board = board;
    });
  }

  void _showBottomSheet(BuildContext context, FormModeFlags flag, Task? task) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return TaskInputForm(
            showSnackBar: _showSnackBar,
            mode: flag,
            updateTask: _updateTask,
            taskState: task,
            boardId: _board.boardId,
          );
        });
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("タスク一覧"),
      ),
      body: Column(
        children: [
          TaskListWidget(
            tasks: _openTasks,
            updateTask: _updateTask,
            title: 'Open',
            initiallyExpanded: true,
            showBottomSheet_: _showBottomSheet,
            updateTaskOrder: _updateTaskOrder,
          ),
          TaskListWidget(
            tasks: _doneTasks,
            updateTask: _updateTask,
            title: 'Closed',
            showBottomSheet_: _showBottomSheet,
            updateTaskOrder: _updateTaskOrder,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showBottomSheet(context, FormModeFlags.NEW,
              Task(taskTitle: "", boardId: _board.boardId));
        },
        tooltip: 'タスク登録',
        child: const Icon(Icons.add),
      ),
    );
  }
}

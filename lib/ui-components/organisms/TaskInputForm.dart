import 'package:flutter/material.dart';
import 'package:frontend/apis/Task/TaskApi.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../../flags/FormModeFlags.dart';
import '../../models/task/Task.dart';
import '../../utils/DateTimeEx.dart';
import '../../utils/Time.dart';

class TaskInputForm extends StatelessWidget {
  late final TextEditingController _textEditingController;
  late final TextEditingController _dateEditingController;
  late final TextEditingController _timeEditingController;
  final Logger _logger = Logger();
  final DateFormat _dateOfDateTime = DateFormat("yyyy-MM-dd");
  final DateFormat _timeOfDateTime = DateFormat("hh:mm");

  //
  final Function(BuildContext, String) showSnackBar;
  final FormModeFlags mode;
  final Task? taskState;
  final void Function(Task newState) updateTask;
  final int boardId;

  //
  TaskInputForm(
      {super.key,
      required this.showSnackBar,
      required this.mode,
      this.taskState,
      required this.updateTask,
      required this.boardId}) {
    _textEditingController =
        TextEditingController(text: taskState?.taskTitle ?? "");
    if (taskState?.deadlineDatetime != null) {
      _dateEditingController = TextEditingController(text: _dateOfDateTime.format(taskState!.deadlineDatetime!));
      _timeEditingController = TextEditingController(text: _timeOfDateTime.format(taskState!.deadlineDatetime!));
    } else {
      _dateEditingController = TextEditingController(text: "");
      _timeEditingController = TextEditingController(text: "");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
              child: Text(
            mode == FormModeFlags.NEW ? "タスク追加" : "タスク編集",
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          )),
          TextField(
            decoration: const InputDecoration(labelText: "タスク名"),
            controller: _textEditingController,
          ),
          Row(
            children: [
              Expanded(
                  child: TextField(
                decoration: const InputDecoration(labelText: "期限日付"),
                controller: _dateEditingController,
                onTap: () async {
                  final year = DateTimeEx.now().year;
                  final DateTime? datetime = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate:
                          DateTimeEx.of(year.year, 1, 1, 0, 0, 0).toDateTime(),
                      lastDate: DateTimeEx(year.lastDay(), Time.of(0, 0, 0))
                          .toDateTime());
                  if (datetime != null) {
                    _dateEditingController.text =
                        _dateOfDateTime.format(datetime);
                    if (_timeEditingController.text == "") {
                      _timeEditingController.text =
                          Time.of(0, 0, 0).format("hh:mm");
                    }
                  }
                },
              )),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(labelText: "期限時刻"),
                  controller: _timeEditingController,
                  onTap: () async {
                    const initTime = TimeOfDay(hour: 0, minute: 0);
                    final TimeOfDay? time = await showTimePicker(
                        context: context, initialTime: initTime);
                    if (time != null) {
                      _timeEditingController.text =
                          Time.from(time ?? initTime).format("hh:mm");
                      if (_dateEditingController.text == "") {
                        _dateEditingController.text = _dateOfDateTime.format(DateTime.now());
                      }
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // textDirection: TextDirection.RTL,
            children: _buildButtons(context),
          )
        ],
      ),
    );
  }

  List<Widget> _buildButtons(BuildContext context) {
    switch (mode) {
      case FormModeFlags.NEW:
        return [
          FilledButton(
              onPressed: () {

                Navigator.pop(context);
                String newTaskName = _textEditingController.text;
                DateTime deadline = DateTime.parse("${_dateEditingController.text}T${_timeEditingController.text}:00");

                TaskApi.getInstance()
                    .addTask(Task(taskTitle: newTaskName, boardId: boardId, deadlineDatetime: deadline))
                    .then((value) =>
                        showSnackBar(context, "\"$newTaskName\"を追加しました。"))
                    .catchError((err) {
                  showSnackBar(context, "エラーが発生しました。");
                  _logger.e(err);
                });
              },
              child: const Text("追加"))
        ]
            .map((e) => Padding(
                  padding: const EdgeInsets.all(5),
                  child: e,
                ))
            .toList();
      case FormModeFlags.EDIT:
        return [
          FilledButton(
              onPressed: () {
                Navigator.pop(context);
                String newTaskName = _textEditingController.text;
                String oldTaskName = taskState?.taskTitle ?? "";
                DateTime deadline = DateTime.parse("${_dateEditingController}T${_timeEditingController}:00");

                _updateTask(taskState ?? Task(taskTitle: "これはバグ！", boardId: -1),
                    newTaskName, deadline);
                showSnackBar(context, "\"$oldTaskName\"を更新しました。");
              },
              child: const Text("更新")),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              String taskName = taskState?.taskTitle ?? "";
              _removeTask(taskState ?? Task(taskTitle: "", boardId: -1));
              showSnackBar(context, "\"$taskName\"を削除しました。");
            },
            style: FilledButton.styleFrom(
                backgroundColor:
                    Theme.of(context).buttonTheme.colorScheme?.error),
            child: const Text("削除"),
          ),
        ]
            .map((e) => Padding(
                  padding: const EdgeInsets.all(5),
                  child: e,
                ))
            .toList();
      case FormModeFlags.READONLY:
        return [];
    }
  }

  void _updateTask(Task task, String newTaskName, [DateTime? deadlineDatetime]) {
    final Task newState = task.copyWith(
        taskTitle: newTaskName, deadlineDatetime: deadlineDatetime);
    updateTask(newState);
  }

  void _removeTask(Task task) {
    TaskApi.getInstance().removeTask(task);
  }
}

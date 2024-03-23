import 'package:flutter/material.dart';
import 'package:frontend/models/board/types/DoneDatetime.dart';
import 'package:frontend/utils/DateTimeEx.dart';

import '../../flags/FormModeFlags.dart';
import '../../models/task/Task.dart';

class TaskWidget extends StatelessWidget {
  final Task task;
  final void Function(Task newState) updateTask;
  final bool bottomBorder;
  final Function(BuildContext context, FormModeFlags flag, Task? task)
      showBottomSheet_;

  const TaskWidget(
      {Key? key,
      required this.task,
      required this.updateTask,
      this.bottomBorder = false,
      required this.showBottomSheet_})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color? tileColor = null;
    if (task.deadlineDatetime?.isBefore(DateTimeEx.now().toDateTime()) ?? false) {
      tileColor = Theme.of(context).buttonTheme.colorScheme?.errorContainer;
    }
    
    return ListTile(
      leading:
          Checkbox(value: task.taskDoneDatetime.value != null, onChanged: _doneTask),
      title: Text(task.taskTitle),
      shape: Border(
          bottom: bottomBorder
              ? const BorderSide(color: Colors.black12)
              : BorderSide.none),
      tileColor: tileColor,
      onTap: () => {showBottomSheet_(context, FormModeFlags.EDIT, task)},
    );
  }

  void _doneTask(bool? b) {
    final Task newState =
        task.copyWith(taskDoneDatetime: (b ?? false) ? DoneDatetime(DateTime.now()) : DoneDatetime());
    updateTask(newState);
  }
}

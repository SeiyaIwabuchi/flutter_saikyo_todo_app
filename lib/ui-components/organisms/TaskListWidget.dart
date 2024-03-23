import 'package:flutter/material.dart';
import 'package:frontend/ui-components/molecules/EmptyTaskWidget.dart';
import 'package:frontend/ui-components/molecules/TaskWidget.dart';
import 'package:frontend/ui-components/organisms/TaskExpansionTile.dart';

import '../../flags/FormModeFlags.dart';
import '../../models/task/Task.dart';

class TaskListWidget extends StatelessWidget {
  final String title;
  final List<Task> tasks;
  final void Function(Task newState) updateTask;
  final void Function(Task target, int index) updateTaskOrder;
  final bool initiallyExpanded;
  final Function(BuildContext context, FormModeFlags flag, Task? task) showBottomSheet_;

  const TaskListWidget(
      {Key? key,
      required this.title,
      required this.tasks,
      required this.updateTask,
      this.initiallyExpanded = false,
      required this.showBottomSheet_,
      required this.updateTaskOrder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TaskExpansionTile(
        title: title,
        initiallyExpanded: initiallyExpanded,
        children: [
          ReorderableListView(
            shrinkWrap: true,
            onReorder: _onReorder,
            children: _buildList(),
          )
        ]);
  }

  List<Widget> _buildList() {
    List<Widget> tiles = [];

    if (tasks.isEmpty) return [EmptyTaskWidget(key: UniqueKey(),)];

    for (int index = 0; index < tasks.length - 1; index++) {
      tiles.add(Column(
        key: UniqueKey(),
        children: [
          TaskWidget(
            task: tasks[index],
            updateTask: updateTask,
            bottomBorder: true,
            showBottomSheet_: showBottomSheet_,
          )
        ],
      ));
    }

    tiles.add(TaskWidget(
        task: tasks.last,
        updateTask: updateTask,
        key: UniqueKey(),
        showBottomSheet_: showBottomSheet_,));

    return tiles;
  }

  void _onReorder(int oldIndex, int newIndex) {
    final task = tasks[oldIndex];
    updateTaskOrder(task, newIndex);
  }
}

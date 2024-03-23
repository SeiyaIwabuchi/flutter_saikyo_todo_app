import 'package:flutter/material.dart';

import '../../models/task/Task.dart';

class EmptyTaskWidget extends StatelessWidget {

  const EmptyTaskWidget(
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      title: Text("タスク無し"),
    );
  }
}

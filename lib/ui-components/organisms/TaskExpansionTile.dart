import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskExpansionTile extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final bool initiallyExpanded;

  const TaskExpansionTile({super.key, required this.title, required this.children, this.initiallyExpanded = false});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(title),
      initiallyExpanded: initiallyExpanded,
      children: children
    );
  }
}
import 'package:flutter/material.dart';
import 'package:frontend/apis/Task/TaskApi.dart';
import 'package:frontend/apis/Task/TaskApiImpl.dart';
import 'package:frontend/apis/board/BoardApi.dart';
import 'package:frontend/apis/board/BoardApiImpl.dart';

import 'apis/commons/Middleware.dart';
import 'pages/MyHomePage.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    TaskApi.init(TaskApiImpl());
    BoardApi.init(BoardApiImpl());
    // Middleware.init(MiddlewareSupabase());
    Middleware.init(MiddlewareSpring());

    return MaterialApp(
      title: '俺の最強Todoリスト',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}
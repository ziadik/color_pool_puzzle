import 'package:flutter/material.dart';

class AppError extends StatelessWidget {
  const AppError({super.key, required this.error, required this.stackTrace});

  final Object error;
  final StackTrace stackTrace;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Text('Произошла ошибка:'), Text(error.toString()), Text(stackTrace.toString())]),
        ),
      ),
    );
  }
}

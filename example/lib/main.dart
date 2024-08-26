import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:gatekeeper/gatekeeper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<void> deviceAuthentication() async {
    bool result = await Gatekeeper.authenticate(reason: 'Example app auth');
    if (kDebugMode) print('Auth results: $result');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Gatekeeper'),
        ),
        body: Center(
          child: MaterialButton(
            color: Colors.teal,
            onPressed: () {
              deviceAuthentication();
            },
            child: const Text(
              'Authenticate',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

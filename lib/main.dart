import 'package:ecommerce/models/user_model.dart';
import 'package:ecommerce/services/user_service.dart';
import 'package:ecommerce/views/start_screen.dart';
import 'package:flutter/material.dart';

void main() {
  User user = User(name: "Seif", email: "seif@gmail.com", password: "123456789");
  UserService().addUsers(user);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StartScreen(),
    );
  }
}

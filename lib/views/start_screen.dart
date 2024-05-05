import 'package:ecommerce/views/login_screen.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child:
      Container(
        color: const Color(0xff11111f),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/Logo buy it.png",),
           const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff44d52c) ),
                onPressed: (){
              Navigator.of(context).pop();
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
            }, child: const Text("Login or Signup",style: TextStyle(color: Colors.white),)),
          ],
        ),
      ),
    );
  }
}

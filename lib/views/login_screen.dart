import 'package:ecommerce/services/user_service.dart';
import 'package:ecommerce/views/home_screen.dart';
import 'package:ecommerce/views/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey=GlobalKey<FormState>();
  bool hidePassword = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  Future<void> cacheUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("currentUser", emailController.text);
  }


  void hiddenPassword()
  {
    hidePassword=!hidePassword;
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff11111f),
      appBar: AppBar(
        centerTitle: true,
        titleTextStyle: const TextStyle(fontSize: 30),
        backgroundColor: const Color(0xff44d52c),
        title: const Text("BUY IT"),
      ),
      body:
          ListView(
            children :[
        Form(
          key : _formKey,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10,),
              Image.asset("assets/Logo buy it.png"),
              const SizedBox(
                height: 5,
              ),
              const Text("Login",style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold,color: Color(0xff44d52c)),),
              Padding(padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                child:
                TextFormField(
                  style: const TextStyle(color: Color(0xff44d52c)),
                  controller: emailController,
                  validator: (value){
                    if(value == null || value.isEmpty)
                    {
                      return "Email must not be empty";
                    }
                    else if(UserService().findUser(emailController.text)==-1)
                      {
                        return "Wrong email";
                      }
                  },
                  decoration: const InputDecoration(label: Text("Enter email"),labelStyle: TextStyle(color: Color(
                      0xff44d52c))),
                ),
              ),
              Padding(padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                child:TextFormField(
                  style: const TextStyle(color: Color(0xff44d52c)),
                  obscureText:hidePassword ,
                  controller: passwordController,
                  validator:(value){
                    if(value == null || value.length <8 )
                    {
                      return "Password must be more than 8 characters";
                    }
                    else if(UserService.users[UserService().findUser(emailController.text)].password != passwordController.text)
                    {
                        return "Wrong Password";
                    }
                  },
                  decoration:  InputDecoration(label: const Text("Enter password"),labelStyle: const TextStyle(color: Color(0xff44d52c)),
                    suffixIcon: IconButton(onPressed: (){
                      hiddenPassword();
                    },
                      icon: Icon(
                        hidePassword?Icons.visibility:Icons.visibility_off,color: const Color(0xff44d52c),
                      ),
                    ),
                  ),
                ),
              ),
              FloatingActionButton(
                backgroundColor: const Color(0xff44d52c),
                onPressed: (){
                if(_formKey.currentState!.validate()){
                  cacheUser();
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomeScreen()));
                }
              },
                child: const Text("Login"),
              ),
              TextButton(onPressed: ()
              {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const SignupScreen()));
              },
                child: const Text("Click Here to signup",style: TextStyle(color: Color(0xff44d52c)),),
              )
            ],
          ),
        ),
  ],
    ),
    );
  }
}



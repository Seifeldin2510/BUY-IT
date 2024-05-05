import 'package:ecommerce/models/user_model.dart';
import 'package:ecommerce/services/user_service.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey=GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool hidePassword = true;
  void hiddenPassword()
  {
    hidePassword=!hidePassword;
    setState(() {

    });
  }
  void addUser()
  {
    UserService().addUsers(User(name: nameController.text, email: emailController.text, password: passwordController.text));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color(0xff11111f),
      appBar: AppBar(
        backgroundColor: const Color(0xff44d52c),
        title: const Text("Signup"),
      ),
      body: Center(
        child:
        Form(
          key : _formKey,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person , size: 90,color: Color(0xff44d52c)),
              Padding(padding: const EdgeInsets.all(4.0),
                child:
                TextFormField(
                  style: const TextStyle(color: Color(0xff44d52c)),
                  controller: nameController,
                  validator: (value){
                    if(value!.isEmpty)
                    {
                      return "Name must not be empty";
                    }
                  },
                  decoration: const InputDecoration(label: Text("Enter Name",),labelStyle: TextStyle(color: Color(0xff44d52c))),
                ),
              ),

              Padding(padding: const EdgeInsets.all(4.0),
                child:
                TextFormField(
                  style: const TextStyle(color: Color(0xff44d52c)),
                  controller: emailController,
                  validator: (value){
                    if(value!.isEmpty)
                    {
                      return "Email must not be empty";
                    }
                  },
                  decoration: const InputDecoration(label: Text("Enter email",style: TextStyle(color: Color(0xff44d52c)),),),
                ),
              ),

              Padding(padding: const EdgeInsets.all(4.0),
                child:TextFormField(
                  style: const TextStyle(color: Color(0xff44d52c)),
                  obscureText:hidePassword ,
                  controller: passwordController,
                  validator:(value){
                    if(value != null && value.length < 8 )
                    {
                      return "Password must be more than 8 characters";
                    }
                  },
                  decoration: InputDecoration(label: const Text("Enter password",style: TextStyle(color: Color(0xff44d52c)),),
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

              Padding(padding: const EdgeInsets.all(4.0),
                child:TextFormField(
                  style: const TextStyle(color: Color(0xff44d52c)),
                  obscureText:hidePassword ,
                  controller: confirmPasswordController,
                  validator:(value){
                    if(value != null && value != passwordController.text )
                    {
                      return "Password must be same as above";
                    }
                  },
                  decoration: InputDecoration(label:const  Text("Confirm password",style: TextStyle(color: Color(0xff44d52c)),),
                    suffixIcon: IconButton(onPressed: (){
                      hiddenPassword();
                    },
                      icon: Icon(
                        hidePassword?Icons.visibility:Icons.visibility_off,color: const Color(0xff44d52c)
                      ),
                    ),
                  ),
                ),
              ),

              FloatingActionButton(
                backgroundColor:const Color(0xff44d52c),
                onPressed: ()
                {
                  if(_formKey.currentState!.validate()){
                    addUser();
                    SnackBar snackBar = SnackBar(
                      backgroundColor: const Color(0xff44d52c),
                      content:
                    const Text("You are signed up"),
                      duration: const Duration(seconds: 5),
                      action: SnackBarAction(
                        textColor: Colors.white,
                        label: "Go to login",
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  else{
                    SnackBar snackBar = SnackBar(
                      backgroundColor: const Color(0xff44d52c),
                      content:
                    const Text("Something is Wrong"),
                      duration: const Duration(seconds: 5),
                      action: SnackBarAction(
                        textColor: Colors.white,
                        label: "Ok",
                        onPressed: (){},
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: const Text("Signup"),
              ),
            ],),
        ),
      ),
    );
  }
}

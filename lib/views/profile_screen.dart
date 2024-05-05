import 'package:ecommerce/models/user_model.dart';
import 'package:ecommerce/services/user_service.dart';
import 'package:ecommerce/views/cart.dart';
import 'package:ecommerce/views/home_screen.dart';
import 'package:ecommerce/views/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User currentUser = User(name: "", email: "", password: "");

  void getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString("currentUser");
     int index = UserService().findUser(email!);
    currentUser = UserService.users[index];
     setState(() {

     });
  }

  Future<void> clearCache() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("currentUser");
  }


  double calculateTotal()
  {
    double total=0;
    for(int i = 0 ;i<currentUser.cart.length;i++)
    {
      total = total +(currentUser.cart[i].quantity*calculateNewPrice(currentUser.cart[i].product.price, currentUser.cart[i].product.discountPercentage));
    }
    return double.parse(total.toStringAsFixed(1));
  }

  double calculateNewPrice(int price , double discount)
  {
    return  double.parse((price * ((100-discount)/100)).toStringAsFixed(1));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff11111f),
      appBar: AppBar(
        backgroundColor:const Color(0xff44d52c),
        title: const Text("Profile",style: TextStyle(fontSize:22,color: Colors.white),),
        actions: [
          IconButton(onPressed: (){
           while(Navigator.of(context).canPop())
             {
               Navigator.of(context).pop();
             }
             Navigator.of(context).pop();
           clearCache();
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const StartScreen()));
          }, icon: const Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const Icon(Icons.person,size: 200,color:Color(0xff44d52c) ,),
            const SizedBox(
              height: 7,
            ),
          Text("Name: ${currentUser.name}",style: const TextStyle(fontSize: 30, color: Color(0xff44d52c)),),
          const SizedBox(
            height: 5,
          ),
          Text("email: ${currentUser.email}",style: const TextStyle(fontSize: 30,color: Color(0xff44d52c)),),
            const SizedBox(
              height: 5,
            ),
          Text("password: ${currentUser.password}",style: const TextStyle(fontSize: 30,color: Color(0xff44d52c)),),
            const SizedBox(
              height: 5,
            ),
            Center(
              child:
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff44d52c) ),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));},
                child: const Center(
                  child: Text(
                      "Continue shopping"
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff44d52c),
        onPressed:() {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) =>  CartScreen(total: calculateTotal(),)));
        },
        child: Badge(
          backgroundColor: const Color(0xff11111f),
          label: Text("${currentUser.itemsInCart}",style: const TextStyle(fontSize: 15),),
          largeSize: 16,
          child: const Icon(Icons.shopping_cart),
        ),
      ),
    );
  }
}

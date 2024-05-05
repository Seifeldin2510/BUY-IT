import 'package:ecommerce/models/user_model.dart';
import 'package:ecommerce/services/user_service.dart';
import 'package:ecommerce/views/home_screen.dart';
import 'package:ecommerce/views/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  double total ;
   CartScreen({super.key,required this.total});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  User currentUser = User(name: "", email: "", password: "");

  void getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString("currentUser");
    int index = UserService().findUser(email!);
    currentUser = UserService.users[index];
    setState(() {

    });
  }
  double calculateNewPrice(int price , double discount)
  {
    return  double.parse((price * ((100-discount)/100)).toStringAsFixed(1));
  }

  removeItem(int index)
{
  currentUser.itemsInCart--;
  widget.total = widget.total-calculateNewPrice(currentUser.cart[index].product.price, currentUser.cart[index].product.discountPercentage);
  double.parse(widget.total.toStringAsFixed(1));
  currentUser.cart[index].quantity--;
  if(currentUser.cart[index].quantity==0)
  {
    currentUser.cart.removeAt(index);
  }
  if(currentUser.itemsInCart == 0)
    {
      widget.total = 0;
    }
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
    title: const Text("Cart",style: TextStyle(fontSize:22,color: Colors.white),),
      actions: [
        IconButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const ProfileScreen()));
        },
            icon: const Icon(Icons.person))
      ],
    ),
       body: Column(
         children: [
          Expanded(
            child: ListView.separated(
              itemCount: currentUser.cart.length,
                itemBuilder: (context,index){
                return ListTile(
                  leading: Image.network(currentUser.cart[index].product.thumbnail),
                  title: Text(currentUser.cart[index].product.title,style: const TextStyle(color:Color(0xff44d52c)),),
                  subtitle: Text("amount : ${currentUser.cart[index].quantity}",style: const TextStyle(color:Color(0xff44d52c)),),
                  trailing: FloatingActionButton(
                      backgroundColor:const Color(0xff44d52c),
                    onPressed:(){ removeItem(index);
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen(total: widget.total)));
                    SnackBar snackBar = SnackBar(
                      backgroundColor: const Color(0xff44d52c),
                      content:
                      const Text("Item is removed"),
                      duration: const Duration(seconds: 6),
                      action: SnackBarAction(
                        textColor: Colors.white,
                        label: "Ok" ,
                        onPressed: (){},
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                    child: const Icon(Icons.delete_forever,color: Colors.red,)
                  ),
                );
                },
                separatorBuilder: (context,index){
                  return const Divider();
                },
                ),
          ),
          Center(
            child:
            Text(
              "Total Amount : ${widget.total}",style: const TextStyle(color:Color(0xff44d52c)),
            ),
          ),
          Center(
            child:
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff44d52c) ),
              onPressed: (){
                currentUser.itemsInCart = 0;
                currentUser.cart.clear();
                while(Navigator.of(context).canPop())
                {
                  Navigator.of(context).pop();
                }
                Navigator.of(context).pop();
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const ProfileScreen()));
                },
              child: const Center(
                child: Text(
                  "Check Out"
                ),
              ),
            ),
          ),
          Center(
            child:
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff44d52c)),
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
    );
  }
}

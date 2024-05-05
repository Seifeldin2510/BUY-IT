import 'package:ecommerce/models/product_model.dart';
import 'package:ecommerce/services/product_service.dart';
import 'package:ecommerce/views/cart.dart';
import 'package:ecommerce/views/product_view.dart';
import 'package:ecommerce/views/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import '../services/user_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  List<Product> product=[];
  bool loading = true;
  User currentUser = User(name: "", email: "", password: "");

  getProducts () async {
    product = await ProductService().getProduct();
    loading = false;
    setState(() {

    });
  }

  void getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString("currentUser");
    int index = UserService().findUser(email!);
    currentUser = UserService.users[index];
    setState(() {

    });
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

  @override
  void initState() {
    super.initState();
    getProducts();
    getUserData();
  }
  double calculateNewPrice(int price , double discount)
  {
    return  double.parse((price * ((100-discount)/100)).toStringAsFixed(1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff11111f),
      appBar: AppBar(
        backgroundColor:const Color(0xff44d52c),
      leading:
           SizedBox(
            width: 0.5,
             child: Image.asset("assets/Logo buy it.png"),
          ),
      title: const Text("Available products",style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const ProfileScreen()));
            },
              icon: const Icon(Icons.person))
        ],
      ),
      body: loading? const Center(
          child: CircularProgressIndicator(color: Color(0xff44d52c),))
          :GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2
      ),
          itemCount: product.length,
          itemBuilder: (context,index){
            return Center(
              child: Padding(padding: const EdgeInsets.all(8.0),
              child:
                Material(
                  color: Color(0xff11111f),
                  elevation: 10,
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                  child: Container(
                   decoration:BoxDecoration(border: Border.all(color: const Color(0xff44d52c))) ,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(product[index].title,style: const TextStyle(fontSize:15,fontWeight: FontWeight.bold ,color: Color(0xff44d52c)),),
                        const SizedBox(
                          height: 1.5,
                        ),
                        InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductView(productData: product[index])));
                            },
                            child: Image.network(product[index].thumbnail,height: 130,)),
                        const SizedBox(
                          height: 1.5,
                        ),
                        if(product[index].discountPercentage==0)
                           Text("\$ ${product[index].price}",
                            style: const TextStyle(
                                fontSize:15,
                                fontWeight: FontWeight.bold ,
                                color: Color(0xff44d52c),
                            ),
                          )
                        else
                          Row(
                            children: [
                              Text("\$ ${product[index].price}",
                                style: const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  decorationThickness: 2.85,
                                  fontSize:15,
                                  fontWeight: FontWeight.bold ,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                width: 1.5,
                              ),
                              Text("\$ ${calculateNewPrice(product[index].price, product[index].discountPercentage)}",
                                style: const TextStyle(
                                  fontSize:15,
                                  fontWeight: FontWeight.bold ,
                                  color: Color(0xff44d52c),
                                ),
                              ),
                            ],
                          ),
                      ],
          ),
                  ),
                ),
              ),
            );
          }
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



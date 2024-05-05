import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce/models/product_model.dart';
import 'package:ecommerce/models/user_model.dart';
import 'package:ecommerce/services/user_service.dart';
import 'package:ecommerce/views/cart.dart';
import 'package:ecommerce/views/home_screen.dart';
import 'package:ecommerce/views/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ProductView extends StatefulWidget {
  Product productData;
  ProductView({super.key , required this.productData});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  User currentUser = User(name: "", email: "", password: "");
  int quantity = 1;

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

  void addToCart()
  {
    currentUser.increaseProductInCart(widget.productData,quantity);
    setState(() {

    });
  }

  void increaseQuantity()
  {
    quantity++;
    setState(() {

    });
  }

  void decreaseQuantity()
  {
    quantity--;
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
    // TODO: implement initState
    super.initState();
    getUserData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff11111f),
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.of(context).pop();
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomeScreen()));
          },
        icon: const Icon(Icons.arrow_back)
          ),
        backgroundColor:const Color(0xff44d52c),
        title:  Text(widget.productData.title,style: const TextStyle(fontSize:22,color: Colors.white),),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const ProfileScreen()));
          },
              icon: const Icon(Icons.person))
        ],
      ),

      body: Center(
        child:ListView(
          children: [
            CarouselSlider.builder(
              itemCount: widget.productData.images.length,
              itemBuilder: (BuildContext context, int index, int pageViewIndex) =>
                  Container(
                    decoration: BoxDecoration(border: Border.all(color: const Color(0xff44d52c))),
                    child: Image.network(widget.productData.images[index]),
                  ),
              options: CarouselOptions(
                  autoPlay: false,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text("Brand : ${widget.productData.brand}",style: const TextStyle(fontSize: 15,color:Color(0xff44d52c)),),
            const SizedBox(
              height: 3,
            ),
            Text("Category : ${widget.productData.category}",style: const TextStyle(fontSize: 15,color:Color(0xff44d52c)),),
            const SizedBox(
              height: 3,
            ),
            Text("Rating : ${widget.productData.rating}",style: const TextStyle(fontSize: 15,color:Color(0xff44d52c)),),
            const SizedBox(
              height: 3,
            ),
            if(widget.productData.discountPercentage==0)
              Text("\$ ${widget.productData.price}",
                style: const TextStyle(
                  fontSize:20,
                  fontWeight: FontWeight.bold ,
                  color: Color(0xff44d52c),
                ),
              )
            else
              Row(
                children: [
                  Text("\$ ${widget.productData.price}",
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      decorationThickness: 2.85,
                      fontSize:20,
                      fontWeight: FontWeight.bold ,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    width: 1.5,
                  ),
                  Text("\$ ${calculateNewPrice(widget.productData.price, widget.productData.discountPercentage)}",
                    style: const TextStyle(
                      fontSize:20,
                      fontWeight: FontWeight.bold ,
                      color: Color(0xff44d52c),
                    ),
                  ),
                ],
              ),
            const SizedBox(
              height: 3,
            ),
            Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor:const Color(0xff44d52c) ),
                          onPressed:decreaseQuantity,
                          child: const Icon(Icons.remove,color: Colors.white,),
                      ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 35,
                        decoration: BoxDecoration(
                          color: const Color(0xff44d52c),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white),
                        ),
                        child: Center(child: Text("$quantity",style: const TextStyle(color:Colors.white),))),
                  ),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff44d52c) ),
                        onPressed:increaseQuantity ,
                        child: const Icon(Icons.add,color: Colors.white,),
                    ),
                  ),
                ],
              ),
            ),
            Text("Left in Stock: ${widget.productData.stock}",style: const TextStyle(fontSize: 15,color:Color(0xff44d52c)),),
            const SizedBox(
              height: 3,
            ),
            TextButton(
                style: TextButton.styleFrom(backgroundColor: const Color(0xff44d52c)),
                onPressed: () {
                  addToCart();
                  SnackBar snackBar = SnackBar(
                    backgroundColor: const Color(0xff44d52c),
                    content:
                  const Text("Added to cart"),
                    duration: const Duration(seconds: 2),
                    action: SnackBarAction(
                      textColor: Colors.white,
                      label: "Ok" ,
                      onPressed: (){},
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                child: const Text("Add to cart",style: TextStyle(color: Colors.white),)),
            const SizedBox(
              height: 3,
            ),
            Text("Description : ${widget.productData.description}",style: const TextStyle(fontSize: 15,color:Color(0xff44d52c)),),
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

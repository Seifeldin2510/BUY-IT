import 'package:ecommerce/models/cart_product_model.dart';
import 'package:ecommerce/models/product_model.dart';

class User {
String name;
String email;
String password;
List<CartProduct> cart =[];
int itemsInCart = 0;

User({required this.name,required this.email,required this.password});



bool checkPassword(String pass)
{
  return password==pass;
}


void addToCart(Product product)
{
  CartProduct cartProduct = CartProduct(product: product);
  cart.add(cartProduct);
}

int findProduct(int index)
{
  for(int i=0;i<cart.length;i++)
    {
      if(cart[i].product.id==index)
        {
          return i;
        }
    }
  return -1;
}

void increaseProductInCart(Product product,int quantity)
{
  int index = findProduct(product.id);
  if(index == -1)
    {
      addToCart(product);
      itemsInCart++;
      for(int i = 0 ; i<(quantity-1);i++)
        {
          cart[cart.length-1].increaseQuantity();
          itemsInCart++;
        }
    }
  else
  {
    for(int i = 0 ;i<quantity;i++)
    {
      cart[index].increaseQuantity();
      itemsInCart++;
    }
  }
}


}
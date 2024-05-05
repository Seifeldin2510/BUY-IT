import 'package:ecommerce/models/product_model.dart';

class CartProduct{
Product product;
int quantity = 0 ;
CartProduct({required this.product})
{
  increaseQuantity();
}

void increaseQuantity()
{
  quantity++;
}

}
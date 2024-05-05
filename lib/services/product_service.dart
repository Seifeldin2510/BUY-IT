import 'package:dio/dio.dart';
import 'package:ecommerce/models/product_model.dart';
import 'package:flutter/cupertino.dart';

class ProductService{
  String endpoint = "https://dummyjson.com/products";

  Future<List<Product>> getProduct() async {
    List<Product> products = [];
    try{
      var response = await Dio().get(endpoint);
      var data = response.data["products"];
      data.forEach((json)
      {
        Product product = Product.fromJson(json);
        products.add(product);
      });
    }
    catch(e)
    {
      debugPrint(e.toString());
    }
    return products;
  }
}
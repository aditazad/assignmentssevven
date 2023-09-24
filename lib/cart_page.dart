import 'package:flutter/material.dart';
import 'product.dart'; // Import the Product class

class CartPage extends StatelessWidget {
  final List<Product> productsInCart; // Ensure this parameter is defined

  CartPage({required this.productsInCart}); // Constructor

  @override
  Widget build(BuildContext context) {
    // Calculate the total number of unique products in the cart
    int totalUniqueProducts = productsInCart.length;

    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: Center(
        child: Text("Total products: $totalUniqueProducts"),
      ),
    );
  }
}
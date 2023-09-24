import 'package:flutter/material.dart';
import 'cart_page.dart'; // Import the CartPage widget
import 'product.dart'; // Import the Product class

void main() {
  runApp(MaterialApp(
    home: ProductList(),
  ));
}

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<Product> products = [];

  ScrollController _scrollController = ScrollController();

  int totalProductsBought = 0; // Initialize total products bought
  List<Product> productsInCart = []; // Initialize the list of products in the cart

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _scrollController.addListener(_loadMore);
  }

  void _loadProducts() {
    // Simulated data for demonstration
    final List<Product> newProducts = List.generate(10, (index) {
      return Product(
        name: 'Product ${products.length + index + 1}',
        price: (index + 1) * 10.0,
        counter: 0,
      );
    });

    setState(() {
      products.addAll(newProducts);
    });
  }

  void _loadMore() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _loadProducts();
    }
  }

  void _incrementCounter(int index) {
    setState(() {
      products[index].counter++;
      totalProductsBought++; // Increment the total products bought

      if (products[index].counter == 5) {
        // Show a dialog when the counter reaches 5
        _showCongratulationsDialog(products[index].name);
      }

      // Check if the product is already in the cart
      final existingProduct = productsInCart.firstWhere(
            (product) => product.name == products[index].name,
        orElse: () => Product(name: '', price: 0.0), // Default Product values
      );

      if (existingProduct.name.isEmpty) {
        // If the product is not in the cart, add it with a quantity of 1
        productsInCart.add(Product(
          name: products[index].name,
          price: products[index].price,
          counter: 1,
        ));
      } else {
        // If the product is already in the cart, update its quantity
        existingProduct.counter++;
      }
    });
  }

  void _showCongratulationsDialog(String productName) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Congratulations!"),
          content: Text("You've bought 5 $productName!"),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _goToCart() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CartPage(productsInCart: productsInCart), // Pass the list of products in the cart
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Product List")),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: products.length + 1,
        itemBuilder: (context, index) {
          if (index < products.length) {
            final product = products[index];
            return ListTile(
              title: Text(product.name),
              subtitle: Text("Price: \$${product.price.toStringAsFixed(2)}"),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Count: ${product.counter}"),
                  ElevatedButton(
                    onPressed: () {
                      _incrementCounter(index);
                    },
                    child: Text("Buy Now"),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: _buildCartButton(), // Add the cart button
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Position the button
    );
  }

  Widget _buildCartButton() {
    return FloatingActionButton(
      onPressed: _goToCart, // Navigate to the CartPage
      child: Icon(Icons.shopping_cart),
    );
  }
}
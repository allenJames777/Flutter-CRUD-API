import 'package:flutter/material.dart';
import 'package:assignment/AddScreen.dart';
import 'package:assignment/base.dart';
import 'package:assignment/UpdateScreen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final LaptopRepository _repository = LaptopRepository();
  late Future<List<dynamic>> _laptopFuture;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _laptopFuture = _repository.getLaptops();
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _laptopFuture = _repository.searchProducts(query);
    });
  }

  void _clearSearchQuery() {
    _searchController.clear();
    _updateSearchQuery('');
  }

  void _refreshPage() {
    setState(() {
      _laptopFuture = _repository.getLaptops();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search Laptops',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _updateSearchQuery,
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _laptopFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const AlertDialog(
                    content: Text('NO DATA CAN BE DISPLAYED'),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error fetching data: ${snapshot.error}',
                      style: const TextStyle(fontSize: 18),
                    ),
                  );
                } else if (!snapshot.hasData ||
                    (snapshot.data as List).isEmpty) {
                  return const Center(
                    child: Text(
                      'No products available.',
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                } else {
                  return ProductListView(
                    products: snapshot.data as List,
                    repository: _repository,
                    onProductDeleted: _refreshPage, // Pass the callback
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddScreen(),
            ),
          );
          if (result != null) {
            _refreshPage(); // Refresh after adding a product
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ProductListView extends StatelessWidget {
  final List<dynamic> products;
  final LaptopRepository repository;
  final VoidCallback onProductDeleted; // Add this line

  const ProductListView({
    Key? key,
    required this.products,
    required this.repository,
    required this.onProductDeleted, // Add this line
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return buildProductTile(product, context);
      },
    );
  }

  Widget buildProductTile(Map<String, dynamic> product, BuildContext context) {
    return ListTile(
      title: Text(product['Product_Name']),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Brand: ${product['Brand']}'),
          Text('Price: ${product['Price']}'),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildEditIconButton(product, context),
          buildDeleteIconButton(product, context),
        ],
      ),
    );
  }

  IconButton buildEditIconButton(
      Map<String, dynamic> product, BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.edit),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UpdateScreen(data: product),
          ),
        );
      },
    );
  }

  IconButton buildDeleteIconButton(
      Map<String, dynamic> product, BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete, color: Colors.red),
      onPressed: () async {
        await showDeleteDialog(context, product);
        onProductDeleted(); // Invoke the callback after deleting a product
      },
    );
  }

  Future<void> showDeleteDialog(
      BuildContext context, Map<String, dynamic> product) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete'),
          content: Text('Deleted Product: ${product['Product_Name']}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Passing false as cancellation
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Passing true as confirmation
              },
              style: TextButton.styleFrom(
                primary: Colors.red, // Set the text color to red
              ),
              child: const Text('Delete'), // Change 'OK' to 'Delete'
            ),
          ],
        );
      },
    );

    if (confirm != null && confirm) {
      await repository.deleteLaptop(product['Id']);
    }
  }
}

import 'package:assignment/ProdPage.dart';
import 'package:assignment/base.dart';

import 'package:flutter/material.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({Key? key, required this.data}) : super(key: key);

  final Map<String, dynamic> data;

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  final LaptopRepository _repository = LaptopRepository();
  TextEditingController productNameController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController processorController = TextEditingController();
  TextEditingController ramController = TextEditingController();
  TextEditingController storageController = TextEditingController();
  TextEditingController screenSizeController = TextEditingController();
  TextEditingController osController = TextEditingController();
  TextEditingController imageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      productNameController.text = widget.data['Product_Name'];
      brandController.text = widget.data['Brand'];
      priceController.text = widget.data['Price'];
      categoryController.text = widget.data['Category'];
      processorController.text = widget.data['Processor'];
      ramController.text = widget.data['RAM'];
      storageController.text = widget.data['Storage'];
      screenSizeController.text = widget.data['Screen_Size'];
      osController.text = widget.data['Operating_System'];
      imageController.text = widget.data['Image'];
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Product'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildTextField(productNameController, 'Product Name'),
            _buildTextField(brandController, 'Brand'),
            _buildTextField(priceController, 'Price'),
            _buildTextField(categoryController, 'Category'),
            _buildTextField(processorController, 'Processor'),
            _buildTextField(ramController, 'RAM'),
            _buildTextField(storageController, 'Storage'),
            _buildTextField(screenSizeController, 'Screen Size'),
            _buildTextField(osController, 'Operating System'),
            _buildTextField(imageController, 'Image'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _updateProduct,
              child: Text(widget.data == null ? 'Update' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
        ),
      ),
    );
  }

  void _updateProduct() async {
    Map<String, dynamic> productData = {
      'Product_Name': productNameController.text,
      'Brand': brandController.text,
      'Price': priceController.text,
      'Category': categoryController.text,
      'Processor': processorController.text,
      'RAM': ramController.text,
      'Storage': storageController.text,
      'Screen_Size': screenSizeController.text,
      'Operating_System': osController.text,
      'Image': imageController.text,
    };

    if (widget.data != null) {
      try {
        await _repository.updateLaptop(
          int.parse(widget.data['Id']),
          productData,
        );

        // Update successful, you might want to show a message or navigate back
        Navigator.of(context).pop(true);
      } catch (e) {
        // Update failed, handle the error
        print('Error during laptop update: $e');
        // You might want to show an error message to the user
      }
    }
  }
}

import 'package:assignment/ProdPage.dart';
import 'package:assignment/base.dart';
import 'package:assignment/main.dart';
import 'package:flutter/material.dart';

class AddScreen extends StatefulWidget {
  final dynamic data;

  const AddScreen({Key? key, this.data}) : super(key: key);

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
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
              onPressed: _saveProduct,
              child: Text(widget.data == null ? 'Add' : 'Update'),
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

  void _saveProduct() async {
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

    if (widget.data == null) {
      await _repository.addLaptop(productData);
    }

    if (context.mounted) {
      Navigator.of(context).pop(true);
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;

class LaptopRepository {
  final String _baseUrl = 'http://allenjames.mooo.com/api2/products.php';
  final String token = 'Y29kZXg6cmVzdF9hcGlfdGVzdAo';

  Future<dynamic> addLaptop(Map<String, dynamic> laptopData) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(laptopData),
    );
    return _processResponse(response);
  }

  // Future<dynamic> updateLaptop(int Id, Map<String, dynamic> laptopData) async {
  //   final response = await http.put(
  //     Uri.parse('http://allenjames.mooo.com/api2/products.php?id=$Id'),
  //     headers: {'Authorization': 'Bearer $token'},
  //     body: jsonEncode(laptopData),
  //   );
  //   return _processResponse(response);
  // }

  Future<dynamic> updateLaptop(int Id, Map<String, dynamic> laptopData) async {
    try {
      final response = await http.put(
        Uri.parse('http://allenjames.mooo.com/api2/products.php?id=$Id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(laptopData),
      );
      return _processResponse(response);
    } catch (e) {
      print('Error during Laptop update: $e');
      throw Exception(
          'Failed to update Laptop: $e'); // Rethrow the exception with a more specific message
    }
  }

  Future<dynamic> deleteLaptop(Id) async {
    final response = await http.delete(
      Uri.parse('http://allenjames.mooo.com/api2/products.php?id=$Id'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return _processResponse(response);
  }

  Future<List<dynamic>> getLaptops() async {
    var url = Uri.parse(_baseUrl);

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    return _processResponse(response);
  }

  dynamic _processResponse(http.Response response) {
    // print('Processing Response - Status Code: ${response.statusCode}');
    // print('Response Body: ${response.body}');

    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 204) {
      print('success');
      return jsonDecode(response.body);
    } else {
      print('Error Response: ${response.body}');
      throw Exception(
          'Failed to process request. Status Code: ${response.statusCode}');
    }
  }

  Future<List<dynamic>> searchProducts(String query) async {
    final allLaptops = await getLaptops(); // Fetch all motorcycles
    if (query.isEmpty) {
      return allLaptops; // Return all motorcycles if the query is empty
    }

    // Filter the motorcycles based on the search query
    final filteredLaptops = allLaptops
        .where((laptop) =>
            laptop['Product_Name'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return filteredLaptops;
  }
}

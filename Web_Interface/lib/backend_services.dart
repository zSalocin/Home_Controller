import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:tcc_2023/paths.dart';

Future<String> registerNewUser(String username, String password) async {
  try {
    var loginUrl = Uri.parse(ApiURL.authRegister);

    var jsonData =
        convert.jsonEncode({'username': username, 'password': password});

    var loginResponse = await http.post(
      loginUrl,
      headers: {'Content-Type': 'application/json'},
      body: jsonData,
    );

    if (loginResponse.statusCode == 201) {
      return 'Register new user successfully';
    } else {
      return 'Registration failed with status: ${loginResponse.statusCode}.';
    }
  } catch (error) {
    return 'Error during registration request: $error';
  }
}

Future<String?> getToken(String username, String password) async {
  try {
    var loginUrl = Uri.parse(ApiURL.authLogin);
    var jsonData =
        convert.jsonEncode({'username': username, 'password': password});
    var loginResponse = await http.post(
      loginUrl,
      headers: {'Content-Type': 'application/json'},
      body: jsonData,
    );
    if (loginResponse.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(loginResponse.body);
      var token = jsonResponse['token'];
      return token;
    } else {
      return null;
    }
  } catch (error) {
    return null;
  }
}

Future<String> addBlock(String token, String blockName) async {
  try {
    var url = Uri.parse(ApiURL.addBlocks);

    var jsonData = convert.jsonEncode({'name': blockName});

    var response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonData,
    );

    if (response.statusCode == 200) {
      return 'Register new block successfully';
    } else {
      print('Response body: ${response.body}');
      return 'Registration failed with status: ${response.statusCode}.';
    }
  } catch (error) {
    return 'Error during registration request: $error';
  }
}

Future<List<Map<String, dynamic>>> getBlocks(String token) async {
  try {
    var url = Uri.parse(ApiURL.getBlocks);

    var response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    print(convert.jsonDecode(response.body));

    if (response.statusCode == 200) {
      List<dynamic> data = convert.json.decode(response.body);
      List<Map<String, dynamic>> items = List<Map<String, dynamic>>.from(data);
      print(items);
      return items;
    } else {
      throw Exception('Failed to load data');
    }
  } catch (error) {
    throw Exception('Error: $error');
  }
}

Future<List<String>> getRooms(String token, String blockName) async {
  try {
    final url = Uri.parse('${ApiURL.getBlocks}$blockName/rooms');

    var jsonData =
        convert.jsonEncode({'Authorization': token, 'blockId': blockName});

    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonData,
    );

    if (response.statusCode == 200) {
      // Parse the response data
      final List<dynamic> responseData = convert.json.decode(response.body);
      // Convert the response data to a List<String>
      final List<String> rooms = responseData.cast<String>();
      return rooms;
    } else {
      // Handle error cases
      throw Exception('Failed to load rooms');
    }
  } catch (error) {
    // Handle exceptions
    print('Error: $error');
    throw Exception('Failed to load rooms');
  }
}

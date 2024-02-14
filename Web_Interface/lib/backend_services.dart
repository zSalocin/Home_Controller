import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:tcc_2023/paths.dart';

// User login settings

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

// Blocks settings

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

    if (response.statusCode == 200) {
      List<dynamic> data = convert.json.decode(response.body);
      List<Map<String, dynamic>> items = List<Map<String, dynamic>>.from(data);
      return items;
    } else {
      throw Exception('Failed to load data');
    }
  } catch (error) {
    throw Exception('Error: $error');
  }
}

// Rooms Settings

Future<String> addRooms(String token, String blockId, String roomName) async {
  try {
    var url = Uri.parse('${ApiURL.baseURL}/blocks/add/$blockId/rooms');

    var jsonData = convert.jsonEncode({'roomName': roomName});

    var response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonData,
    );

    if (response.statusCode == 200) {
      return 'Register new room successfully';
    } else {
      return 'Registration failed with status: ${response.statusCode}.';
    }
  } catch (error) {
    return 'Error during registration request: $error';
  }
}

Future<List<String>> getRooms(String token, String blockId) async {
  try {
    var url = Uri.parse('${ApiURL.getBlocks}/$blockId/allRooms');

    var response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      List<dynamic> data = convert.json.decode(response.body);
      List<String> roomNames =
          data.map((room) => room['roomName'] as String).toList();
      return roomNames;
    } else {
      throw Exception('Failed to load data');
    }
  } catch (error) {
    throw Exception('Error: $error');
  }
}

// Element settings

Future<String> addElement(
    {required String token,
    required String blockId,
    required String roomName,
    required bool enable,
    required bool stats,
    required int pin,
    required String elementName,
    required String elementType,
    List<int>? attachPins}) async {
  try {
    var url = Uri.parse('${ApiURL.baseURL}/blocks/add/$blockId/elements');

    var jsonData = convert.jsonEncode({
      'enable': enable,
      'stats': stats,
      'pin': pin,
      'elementName': elementName,
      'elementRoom': roomName,
      'elementType': elementType,
      'attachPins': attachPins
    });

    var response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonData,
    );

    if (response.statusCode == 200) {
      return 'Register new element successfully';
    } else {
      return 'Registration failed with status: ${response.statusCode}.';
    }
  } catch (error) {
    return 'Error during registration request: $error';
  }
}

Future<String> addAttachtoElement({
  required String token,
  required String blockId,
  required String elementId,
  required int attachPin,
}) async {
  try {
    var url =
        Uri.parse('${ApiURL.baseURL}/blocks/add/$blockId/elements/$elementId');

    var jsonData = convert.jsonEncode({'attachPin': attachPin});

    var response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonData,
    );

    if (response.statusCode == 200) {
      return 'Register new attach successfully';
    } else {
      return 'Registration failed with status: ${response.statusCode}.';
    }
  } catch (error) {
    return 'Error during registration request: $error';
  }
}

Future<List<Map<String, dynamic>>> getElements(
    String token, String blockId) async {
  try {
    final url = Uri.parse('${ApiURL.baseURL}/public/get/$blockId/allElements');

    var response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      List<dynamic> data = convert.json.decode(response.body);
      List<Map<String, dynamic>> items = List<Map<String, dynamic>>.from(data);
      return items;
    } else {
      throw Exception('Failed to load data');
    }
  } catch (error) {
    throw Exception('Error: $error');
  }
}

Future<List<Map<String, dynamic>>> getElementsforRoom(
    String token, String blockId, String roomName) async {
  try {
    final url =
        Uri.parse('${ApiURL.getBlocks}/$blockId/rooms/$roomName/elements');

    var response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      List<dynamic>? data = convert.json.decode(response.body);
      if (data != null) {
        List<Map<String, dynamic>> items =
            List<Map<String, dynamic>>.from(data);
        return items;
      } else {
        // Retorna uma lista vazia se não houver dados
        return [];
      }
    } else {
      throw Exception('Failed to load data');
    }
  } catch (error) {
    throw Exception('Error: $error');
  }
}

// Requests settings
Future<String> addRequest(String token, String blockId, String requestName,
    String time, int pin, bool stats) async {
  try {
    var url = Uri.parse('${ApiURL.baseURL}/blocks/add/$blockId/requests');

    var jsonData = convert.jsonEncode({
      'name': requestName,
      'time': time,
      'pin': pin,
      'stats': stats,
    });

    var response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonData,
    );

    if (response.statusCode == 200) {
      return 'Register new request successfully';
    } else {
      return 'Registration failed with status: ${response.statusCode}.';
    }
  } catch (error) {
    return 'Error during registration request: $error';
  }
}

// Future<List<String>> getRequest(String token, String blockId) async {
//   try {
//     var url = Uri.parse('${ApiURL.baseURL}/public/get/$blockId/requests');

//     var response = await http.get(url, headers: {
//       'Authorization': 'Bearer $token',
//     });

//     print(convert.jsonDecode(response.body));

//     if (response.statusCode == 200) {
//       List<dynamic> data = convert.json.decode(response.body);
//       List<String> roomNames =
//           data.map((room) => room['roomName'] as String).toList();
//       print(roomNames);
//       return roomNames;
//     } else {
//       throw Exception('Failed to load data');
//     }
//   } catch (error) {
//     throw Exception('Error: $error');
//   }
// }

Future<List<Map<String, dynamic>>> getRequest(
    String token, String blockId) async {
  try {
    final url = Uri.parse('${ApiURL.baseURL}/public/get/$blockId/requests');

    var response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      List<dynamic> data = convert.json.decode(response.body);
      List<Map<String, dynamic>> items = List<Map<String, dynamic>>.from(data);
      return items;
    } else {
      throw Exception('Failed to load data');
    }
  } catch (error) {
    throw Exception('Error: $error');
  }
}

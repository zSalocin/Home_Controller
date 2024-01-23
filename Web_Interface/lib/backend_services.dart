import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

void main(List<String> arguments) async {
  // Replace 'http://localhost:8080/blocks' with your actual endpoint
  var getUrl = Uri.parse('http://localhost:8080/blocks');

  try {
    var getResponse = await http.get(getUrl).timeout(
      const Duration(seconds: 1),
      onTimeout: () {
        // Time has run out, return a timeout response
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    );

    if (getResponse.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(getResponse.body);
      print(jsonResponse);
      if (jsonResponse is List) {
        // Handle List (Array) response
        print('GET Response is a List: $jsonResponse');
      } else if (jsonResponse is Map<String, dynamic>) {
        // Handle Map (Object) response
        print('GET Response is a Map: $jsonResponse');
      } else {
        print('GET Response has an unexpected format');
      }
    } else {
      print('GET Request failed with status: ${getResponse.statusCode}.');
    }
  } catch (error) {
    print('Error during the GET request: $error');
  }
}

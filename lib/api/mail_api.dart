import 'dart:convert';
import 'package:http/http.dart' as http;

class MailApi {
  static const String baseUrl = 'https://api.mail.tm';

  // Generate a random email
  static Future<Map<String, dynamic>> createTempAccount() async {
    final domainResponse = await http.get(Uri.parse('$baseUrl/domains'));
    final domainData = json.decode(domainResponse.body);
    final domain = domainData['hydra:member'][0]['domain'];

    final randomEmail = '${DateTime.now().millisecondsSinceEpoch}@$domain';
    final password = 'temppassword123';

    final response = await http.post(
      Uri.parse('$baseUrl/accounts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'address': randomEmail,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      return {
        'email': randomEmail,
        'password': password,
      };
    } else {
      throw Exception('Failed to create email');
    }
  }

  // Login to get token
  static Future<String> getAuthToken(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/token'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'address': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['token'];
    } else {
      throw Exception('Failed to get auth token');
    }
  }

  // Fetch inbox messages
  static Future<List<dynamic>> getInbox(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/messages'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/ld+json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['hydra:member'];
    } else {
      throw Exception('Failed to load inbox');
    }
  }
}

import 'dart:convert';

import 'package:http/http.dart' as http;

class MailApi {
  static const String baseUrl = 'https://api.mail.tm';

  static Future<Map<String, dynamic>> createTempAccount() async {
    try {
      final domainResponse = await http.get(Uri.parse('$baseUrl/domains'));

      if (domainResponse.statusCode != 200) {
        throw Exception('Failed to fetch domains: ${domainResponse.statusCode}');
      }

      final domainData = json.decode(domainResponse.body);
      final domains = domainData['hydra:member'] as List?;

      if (domains == null || domains.isEmpty) {
        throw Exception('No domains available');
      }

      final domain = domains[0]['domain'];
      final randomEmail = 'user${DateTime.now().millisecondsSinceEpoch}@$domain';
      final password = 'TempPass123!'; // Stronger password

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
        throw Exception('Failed to create email: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating account: $e');
    }
  }

  static Future<String> getAuthToken(String email, String password) async {
    try {
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
        return data['token'] ?? '';
      } else {
        throw Exception('Failed to get auth token: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error getting token: $e');
    }
  }

  static Future<List<dynamic>> getInbox(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/messages'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/ld+json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['hydra:member'] ?? [];
      } else {
        throw Exception('Failed to load inbox: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading inbox: $e');
    }
  }
}
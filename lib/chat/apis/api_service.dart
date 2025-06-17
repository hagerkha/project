import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
    static String apiKey = 'AIzaSyCv5otFkSU3iU05aJXsHMm0_tMx1Lj13Z8';

    static Future<String> generateReply(String prompt) async {
        const model = 'gemini-1.5-flash';
        final url = Uri.parse(
            'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$apiKey',
        );

        try {
            final response = await http.post(
                url,
                headers: {'Content-Type': 'application/json'},
                body: jsonEncode({
                    'contents': [
                        {
                            'parts': [
                                {'text': prompt}
                            ]
                        }
                    ]
                }),
            );

            if (response.statusCode == 200) {
                final data = jsonDecode(response.body);
                return data['candidates'][0]['content']['parts'][0]['text'] ?? 'No reply';
            } else {
                return '❌ Error: ${response.body}';
            }
        } catch (e) {
            return '💥 Exception: $e';
        }
    }
}

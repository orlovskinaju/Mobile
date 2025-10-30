import 'package:http/http.dart' as http;
import 'dart:convert';

String _key = "live_yeFTqHKvsdnK2Kfd5OgEnyBhyWcm7DpUnhdhatOTvSpBS6fl1SRIE7RfQoTRjvyO";

class DogService {
  Future<List<dynamic>> getDogs(String search, int offset) async {
    http.Response response;
    
    int page = (offset ~/ 20) + 1;
    
    if (search.isEmpty) {
      response = await http.get(
        Uri.parse(
          "https://api.thedogapi.com/v1/images/search?limit=20&page=$page&order=Desc"
        ),
        headers: {
          'x-api-key': _key
        }
      );
    } else {
      // buscar por raça
      var breedsResponse = await http.get(
        Uri.parse("https://api.thedogapi.com/v1/breeds/search?q=$search"),
        headers: {'x-api-key': _key}
      );
      
      var breeds = json.decode(breedsResponse.body);
      if (breeds.isNotEmpty) {
        String breedId = breeds[0]['id'].toString();
        response = await http.get(
          Uri.parse(
            "https://api.thedogapi.com/v1/images/search?limit=20&breed_id=$breedId&page=$page"
          ),
          headers: {'x-api-key': _key}
        );
      } else {
        return [];
      }
    }
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Falha ao carregar dados: ${response.statusCode}');
    }
  }
}
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Service {
  final String baseUrl = 'https://api.balldontlie.io/v1';
  final String apiKey = '8cf02eb5-c671-4725-81d0-7b14bef88707';

  Future<String> getTeamById(int id) async {
  final url = Uri.parse('$baseUrl/teams/$id');

  final response = await http.get(url, headers: {
    'Authorization': apiKey, 
  });

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print('Equipo recibido ID $id: $data');
    final team = data['data'];  
    return team['full_name'] as String;
  } else {
    throw Exception('Error al obtener equipo $id');
  }

  
}
}

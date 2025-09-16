import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class InvertextoService {
  final String _token = "21565|T9Y9tgMK1OIykx2q0lzCDCbsEHo0JQFo";

  Future<Map<String, dynamic>> convertePorExtenso(String? valor, String? currency) async {
    try {
      final uri = Uri.parse(
        "https://api.invertexto.com/v1/number-to-words?token=${_token}&number=${valor}&language=pt&currency=${currency}",
      );
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Erro ${response.statusCode}: ${response.body}');
      }
    } on SocketException {
      throw Exception('Sem conexão com a internet');
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> buscaCEP(String? valor) async {
    try {
      final uri = Uri.parse(
        "https://api.invertexto.com/v1/cep/${valor}?token=${_token}",
      );
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Erro ${response.statusCode}: ${response.body}');
      }
    } on SocketException {
      throw Exception('Sem conexão com a internet');
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> validaCPF(String? valor) async {
    try {
      final uri = Uri.parse(
        "https://api.invertexto.com/v1/validator?token=${_token}&value=${valor}",
      );
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Erro ${response.statusCode}: ${response.body}');
      }
    } on SocketException {
      throw Exception('Sem conexão com a internet');
    } catch (e) {
      rethrow;
    }
  }
}

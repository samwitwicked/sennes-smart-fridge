import 'package:http/http.dart' as http;
import 'response.dart';
import 'request.dart';
import 'dart:convert';

class ServerApi {
  static ServerApi _instance;

  ServerApi();

  static ServerApi getInstance() {
    if (_instance != null) {
      return _instance;
    }
    return _instance = new ServerApi();
  }

  Future<Response> fetchRequest(Request request) async {
    var url = 'http://sennes.n-gao.de/api?request=';
    var reqString = json.encode(request.toJson());
    final response = await http.get(url + reqString);
    if (response.statusCode == 200) {
      return Response.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to access webserver!');
    }
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'info.dart';

class ApiService {
  final String url =
      'https://pomodoroapp20211116010908.azurewebsites.net/api/People';

  // GET FUNCTION
  Future<List<Info>> getInfo() async {
    var response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      print('EXITO: ' + jsonResponse['entries'][0]['API']);

      return (jsonResponse['entries'] as List)
          .map((e) => Info.fromJSON(e))
          .toList();
    }
    throw Exception('Error al llamar al API');
  }

  Future<Info> getInfoId(int id) async {
    var response = await http.get(Uri.parse(url + '/$id'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      return Info.fromJSON(jsonDecode(response.body));
    }
    throw Exception('Error al llamar al API');
  }

  Future<void> postInfo(Info info) async {
    Map data = {
      'name': info.name,
      'tarea': info.tarea,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(data),
    );
    print(jsonEncode(data));
    if (response.statusCode != 201) throw Exception('Fallo al crear persona');
  }

  Future<void> putInfo(int? api, Info info) async {
    Map data = {
      'personId': api,
      'name': info.name,
      'tarea': info.tarea,
    };

    final response = await http.put(
      Uri.parse(url + '/$api'),
      headers: {
        "Content-Type": "application/json",
        'Accept': 'application/json',
      },
      body: jsonEncode(data),
    );

    print(jsonEncode(data));

    if (response.statusCode != 204) throw Exception('Hubo falla');
  }

  Future<void> deleteInfo(int? api) async {
    print("id $api");
    final response = await http.delete(
      Uri.parse(url + '/$api'),
      headers: {
        "Content-Type": "application/json",
        'Accept': 'application/json',
      },
    );

    if (response.statusCode != 204) throw Exception('Hubo falla');
  }
}

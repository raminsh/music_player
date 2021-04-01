import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:music_player/models/song.dart';

class ApiException implements Exception {
  String _message;
  dynamic _detail;

  get message => _message;
  get detail => _detail;

  ApiException(message, detail) {
    _message = message;
    _detail = detail;
  }

  ApiException.fromJson(String jsonError) {
    try {
      Map<String, dynamic> error = json.decode(jsonError);
      _message = error['errorMessage'];
      _message ??= 'Invalid json';

      _detail = error['queryParameters'];
      _detail ??= '';
    } catch (e) {
      _message = 'Invalid json.';
    }
  }

  @override
  String toString() {
    return '$_message: $_detail';
  }
}

class ItunesApi {
  final http.Client client;

  /// Intantiate the class with optional `http.Client` [client]. 
  /// Use of [client] is useful in unit testing e.g. when using MockIto package.
  ItunesApi({this.client});

  Future<List<Song>> getSearchResults(String searchTerm) async {
    Uri uri = Uri.https('itunes.apple.com', 'search', {
      'term': searchTerm,
      'media': 'music',
      'attribute': 'artistTerm',
    });

    try {
      http.Response res = this.client == null
          ? await http.get(uri)
          : await client.get(uri);

      if (res.statusCode == 200) {
        Map<String, dynamic> out = json.decode(res.body);

        // An extra cautious sanity check. Making sure that we only continue if the json includes 'results'.
        if (out['results'] == null)
          throw ApiException('Invalid json response',
              'Expecting \'results\' field, but none found.');

        List<Song> songs = Song().fromJsonList(out['results']);

        return songs;
      } else if (res.statusCode == 400) {
        Map<String, dynamic> out = json.decode(res.body);

        // Documentation on iTunes API error conditions is incomplete. Certain issues return a json with 'errorMessage'.
        // Catching errors and converting them to our own ApiException for better handling.
        out['errorMessage'] != null
            ? throw ApiException.fromJson(res.body)
            : throw ApiException('Invalid json response',
                'Expecting \'results\' field but none found.');
      }

      throw Exception(res.body);
    } on ApiException catch (e) {
      print('API invokation failed: ${e.toString()}');
      rethrow;
    } catch (e) {
      print('API invokation failed');
      // Propagate the error
      rethrow;
    }
  }
}
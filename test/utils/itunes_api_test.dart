import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:music_player/utils/itunes_api.dart';

// Generate a MockClient using the Mockito package.
// Create new instances of this class in each test.
@GenerateMocks([http.Client])
void main() {
  group('ITunesApi.getSearchResults()', () {
    test('500 - Internal server error returned', () async {
      final body = 'Internal server error';
      final client = MockClient((request) async {
        return http.Response(body, 500);
      });

      try {
        await ItunesApi(client: client).getSearchResults('');
        // We are supposed to get an exception. Test has failed if we are here.
        expect(1, 0);
      } catch (e) {
        expect(e.message, body);
      }
    });

    test('400 - Format error returned', () async {
      final body = ''' 
        {
        "errorMessage":"Invalid value(s) for key(s): [resultEntity]",
        "queryParameters":{"output":"json", "callback":"A javascript function to handle your search results", "country":"ISO-2A country code", "limit":"The number of search results to return", "term":"A search string", "lang":"ISO-2A language code"}
        }      
      ''';
      final client = MockClient((request) async {
        return http.Response(body, 400);
      });

      try {
        await ItunesApi(client: client).getSearchResults('');
        // We are supposed to get an exception. Test has failed if we are here.
        expect(1, 0);
      } on ApiException catch (e) {
        expect(e.message, 'Invalid value(s) for key(s): [resultEntity]');
      } catch (e) {
        expect(1, 0);
      }
    });
  });

  test('No results returned', () async {
    final body = ''' 
        {
        "resultCount":0,
        "results": []
        }      
    ''';
    final client = MockClient((request) async {
      return http.Response(body, 200);
    });

    var songs = await ItunesApi(client: client).getSearchResults('');
    expect(songs.length, 0);
  });

  test('Some results returned', () async {
    final body = ''' 
      {
      "resultCount":3,
      "results": [
      {"wrapperType":"track", "kind":"song", "artistId":372976, "collectionId":1422648512, "trackId":1422648513, "artistName":"ABBA", "collectionName":"Gold: Greatest Hits", "trackName":"Dancing Queen", "collectionCensoredName":"Gold: Greatest Hits", "trackCensoredName":"Dancing Queen", "artistViewUrl":"https://music.apple.com/us/artist/abba/372976?uo=4", "collectionViewUrl":"https://music.apple.com/us/album/dancing-queen/1422648512?i=1422648513&uo=4", "trackViewUrl":"https://music.apple.com/us/album/dancing-queen/1422648512?i=1422648513&uo=4", 
      "previewUrl":"https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview124/v4/0d/b5/d4/0db5d46f-a096-67cc-a3ea-5eaeb10a5102/mzaf_1462611441023793043.plus.aac.p.m4a", "artworkUrl30":"https://is5-ssl.mzstatic.com/image/thumb/Music114/v4/29/55/05/29550595-ee55-5de9-24c6-01358267fc42/source/30x30bb.jpg", "artworkUrl60":"https://is5-ssl.mzstatic.com/image/thumb/Music114/v4/29/55/05/29550595-ee55-5de9-24c6-01358267fc42/source/60x60bb.jpg", "artworkUrl100":"https://is5-ssl.mzstatic.com/image/thumb/Music114/v4/29/55/05/29550595-ee55-5de9-24c6-01358267fc42/source/100x100bb.jpg", "collectionPrice":7.99, "trackPrice":1.29, "releaseDate":"1976-08-15T12:00:00Z", "collectionExplicitness":"notExplicit", "trackExplicitness":"notExplicit", "discCount":1, "discNumber":1, "trackCount":19, "trackNumber":1, "trackTimeMillis":231844, "country":"USA", "currency":"USD", "primaryGenreName":"Pop", "isStreamable":true}, 
      {"wrapperType":"track", "kind":"song", "artistId":372976, "collectionId":1422648512, "trackId":1422648821, "artistName":"ABBA", "collectionName":"Gold: Greatest Hits", "trackName":"Mamma Mia", "collectionCensoredName":"Gold: Greatest Hits", "trackCensoredName":"Mamma Mia", "artistViewUrl":"https://music.apple.com/us/artist/abba/372976?uo=4", "collectionViewUrl":"https://music.apple.com/us/album/mamma-mia/1422648512?i=1422648821&uo=4", "trackViewUrl":"https://music.apple.com/us/album/mamma-mia/1422648512?i=1422648821&uo=4", 
      "previewUrl":"https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview114/v4/ec/d1/bb/ecd1bbf5-1205-e913-55e6-93b24de09d13/mzaf_8162184656178593857.plus.aac.p.m4a", "artworkUrl30":"https://is5-ssl.mzstatic.com/image/thumb/Music114/v4/29/55/05/29550595-ee55-5de9-24c6-01358267fc42/source/30x30bb.jpg", "artworkUrl60":"https://is5-ssl.mzstatic.com/image/thumb/Music114/v4/29/55/05/29550595-ee55-5de9-24c6-01358267fc42/source/60x60bb.jpg", "artworkUrl100":"https://is5-ssl.mzstatic.com/image/thumb/Music114/v4/29/55/05/29550595-ee55-5de9-24c6-01358267fc42/source/100x100bb.jpg", "collectionPrice":7.99, "trackPrice":0.69, "releaseDate":"1975-04-21T12:00:00Z", "collectionExplicitness":"notExplicit", "trackExplicitness":"notExplicit", "discCount":1, "discNumber":1, "trackCount":19, "trackNumber":4, "trackTimeMillis":212304, "country":"USA", "currency":"USD", "primaryGenreName":"Pop", "isStreamable":true}, 
      {"wrapperType":"track", "kind":"song", "artistId":372976, "collectionId":1422648512, "trackId":1422648844, "artistName":"ABBA", "collectionName":"Gold: Greatest Hits", "trackName":"The Winner Takes It All", "collectionCensoredName":"Gold: Greatest Hits", "trackCensoredName":"The Winner Takes It All", "artistViewUrl":"https://music.apple.com/us/artist/abba/372976?uo=4", "collectionViewUrl":"https://music.apple.com/us/album/the-winner-takes-it-all/1422648512?i=1422648844&uo=4", "trackViewUrl":"https://music.apple.com/us/album/the-winner-takes-it-all/1422648512?i=1422648844&uo=4", 
      "previewUrl":"https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview124/v4/f7/74/0d/f7740d8c-1e32-4443-4ef1-257a6f328cee/mzaf_8645402864852917978.plus.aac.p.m4a", "artworkUrl30":"https://is5-ssl.mzstatic.com/image/thumb/Music114/v4/29/55/05/29550595-ee55-5de9-24c6-01358267fc42/source/30x30bb.jpg", "artworkUrl60":"https://is5-ssl.mzstatic.com/image/thumb/Music114/v4/29/55/05/29550595-ee55-5de9-24c6-01358267fc42/source/60x60bb.jpg", "artworkUrl100":"https://is5-ssl.mzstatic.com/image/thumb/Music114/v4/29/55/05/29550595-ee55-5de9-24c6-01358267fc42/source/100x100bb.jpg", "collectionPrice":7.99, "trackPrice":1.29, "releaseDate":"1980-07-21T12:00:00Z", "collectionExplicitness":"notExplicit", "trackExplicitness":"notExplicit", "discCount":1, "discNumber":1, "trackCount":19, "trackNumber":8, "trackTimeMillis":294806, "country":"USA", "currency":"USD", "primaryGenreName":"Pop", "isStreamable":true}]
      }
    ''';
    final client = MockClient((request) async {
      return http.Response(body, 200);
    });

    var songs = await ItunesApi(client: client).getSearchResults('');
    expect(songs.length, 3);
  });

  test('200 - missing results field', () async {
    final body = ''' 
      {
      "resultCount":1,
      "entries": [
      {"wrapperType":"track", "kind":"song", "artistId":372976, "collectionId":1422648512, "trackId":1422648513, "artistName":"ABBA", "collectionName":"Gold: Greatest Hits", "trackName":"Dancing Queen", "collectionCensoredName":"Gold: Greatest Hits", "trackCensoredName":"Dancing Queen", "artistViewUrl":"https://music.apple.com/us/artist/abba/372976?uo=4", "collectionViewUrl":"https://music.apple.com/us/album/dancing-queen/1422648512?i=1422648513&uo=4", "trackViewUrl":"https://music.apple.com/us/album/dancing-queen/1422648512?i=1422648513&uo=4", 
      "previewUrl":"https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview124/v4/0d/b5/d4/0db5d46f-a096-67cc-a3ea-5eaeb10a5102/mzaf_1462611441023793043.plus.aac.p.m4a", "artworkUrl30":"https://is5-ssl.mzstatic.com/image/thumb/Music114/v4/29/55/05/29550595-ee55-5de9-24c6-01358267fc42/source/30x30bb.jpg", "artworkUrl60":"https://is5-ssl.mzstatic.com/image/thumb/Music114/v4/29/55/05/29550595-ee55-5de9-24c6-01358267fc42/source/60x60bb.jpg", "artworkUrl100":"https://is5-ssl.mzstatic.com/image/thumb/Music114/v4/29/55/05/29550595-ee55-5de9-24c6-01358267fc42/source/100x100bb.jpg", "collectionPrice":7.99, "trackPrice":1.29, "releaseDate":"1976-08-15T12:00:00Z", "collectionExplicitness":"notExplicit", "trackExplicitness":"notExplicit", "discCount":1, "discNumber":1, "trackCount":19, "trackNumber":1, "trackTimeMillis":231844, "country":"USA", "currency":"USD", "primaryGenreName":"Pop", "isStreamable":true}]
      }
      ''';
    final client = MockClient((request) async {
      return http.Response(body, 200);
    });

    try {
      await ItunesApi(client: client).getSearchResults('');
      // We are supposed to get an exception. Test has failed if we are here.
      expect(1, 0);
    } catch (e) {
      expect(e, isA<ApiException>());
    }
  });

  test('400 - missing errorMessage field', () async {
    final body = ''' 
      {
      "error":"Invalid value(s) for key(s): [resultEntity]",
      "queryParameters":{"output":"json", "callback":"A javascript function to handle your search results", "country":"ISO-2A country code", "limit":"The number of search results to return", "term":"A search string", "lang":"ISO-2A language code"}
      }      
      ''';
    final client = MockClient((request) async {
      return http.Response(body, 400);
    });

    try {
      await ItunesApi(client: client).getSearchResults('');
      // We are supposed to get an exception. Test has failed if we are here.
      expect(1, 0);
    } catch (e) {
      expect(e, isA<ApiException>());
    }
  });
}
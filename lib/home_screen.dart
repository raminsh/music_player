import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:music_player/models/song.dart';
import 'package:music_player/utils/itunes_api.dart';
import 'package:music_player/widgets/expanded_section.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Song> _songsList;
  var _searchTerm = '';
  var _currentVolume = 0.4;

  /// The index of the currently selected song (being played) in _songsList is hold globally,
  /// so that it can be used to navigate to previous/next songs and to show the playing indicator.
  int _currentlySelectedSongIndex;

  /// Placeholder album artwork if the song does not have its own.
  var _placeholderArtwork =
      Image.asset('assets/images/no_artwork_available.png');

  var _isSearching = false;
  var _isPlaying = false;
  var _noResultsFound = false;
  var _showMusicControlsBar = false;

  var _controller = TextEditingController();

  /// Controller used to scroll to the top of the search results area when a new search is done
  var _listViewController = ScrollController();

  AudioPlayer _audioPlayer = AudioPlayer();

  Future<List<Song>> _retriveResults(searchTerm) async {
    return await ItunesApi().getSearchResults(searchTerm);
  }

  Future<void> _play(int index) async {
    int result = await _audioPlayer.play(_songsList[index].previewUrl,
        volume: _currentVolume);

    // Means AudioPlayer plugin has been successful in starting to play.
    if (result == 1) {
      setState(() {
        _showMusicControlsBar = true;
      });
    }
  }

  Future<void> playPreviousSong() async {
    _currentlySelectedSongIndex = _currentlySelectedSongIndex - 1;

    await _play(_currentlySelectedSongIndex);
  }

  Future<void> playNextSong() async {
    _currentlySelectedSongIndex = _currentlySelectedSongIndex + 1;

    await _play(_currentlySelectedSongIndex);
  }

  /// Shows a text in the form a toast, with a predefined set of stylings.
  static void showText(
      {@required String text,
      Duration duration = const Duration(seconds: 4),
      crossPage = false}) {
    BotToast.showText(
      text: text,
      textStyle: TextStyle(fontSize: 16),
      duration: duration,
      contentColor: Colors.blue,
      contentPadding: EdgeInsets.all(15.0),
      crossPage: crossPage,
    );
  }

  /// Called when either user clicks on the search icon or the text field form in the search bar is submitted.
  Future<void> search(_searchTerm) async {
    // Resetting the flags.
    _currentlySelectedSongIndex = null;
    _noResultsFound = false;
    setState(() {
      _isSearching = true;
    });

    try {
      _songsList = await _retriveResults(_searchTerm);

      // Need to check if the controller actually has clients before animating
      // to the top of the list when a new search is done.
      if (_listViewController.hasClients)
        _listViewController.animateTo(0,
            duration: Duration(milliseconds: 500), curve: Curves.easeIn);

      if (_songsList.length == 0) _noResultsFound = true;

      setState(() {
        _isSearching = false;
      });
    } on ApiException {
      setState(() {
        _isSearching = false;
      });
      showText(
          text: 'An unexpected error has occured, please contact support.');
    } catch (e) {
      setState(() {
        _isSearching = false;
      });
      showText(
          text:
              'Cannot reach the server, please check your internet connection and try again.');
    }
  }

  /// Widget displaying a spinner while loading results.
  Widget _loadingSpinner() {
    return SpinKitCircle(
      color: Colors.blue,
      size: 30.0,
    );
  }

  /// Widget displaying a single search result item in the search results area list view.
  Widget _resultItem(int index) {
    return GestureDetector(
      onTap: () {
        _play(index);
        _currentlySelectedSongIndex = index;
      },
      child: Card(
        elevation: 2,
        margin: EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3),
        ),
        child: Row(
          children: [
            // Widget displaying the artwork of the song.
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 25.0, 20.0, 25.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: Container(
                  width: 80,
                  height: 80,
                  child: _songsList[index].artworkUrl != null
                      ? Image.network(
                          _songsList[index].artworkUrl,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          '$_placeholderArtwork',
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),

            // Widget displaying song name, artist name and album name.

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _songsList[index].trackName != null
                          ? _songsList[index].trackName
                          : 'Unknown Track',
                      style: Theme.of(context).textTheme.subtitle1,
                      textScaleFactor: 1.1,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                        _songsList[index].artistName != null
                            ? _songsList[index].artistName
                            : 'Unknown Artist',
                        style: Theme.of(context).textTheme.bodyText2),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                        _songsList[index].collectionName != null
                            ? _songsList[index].collectionName
                            : 'Unknown Album',
                        style: Theme.of(context).textTheme.caption),
                  ],
                ),
              ),
            ),

            // Widget displaying the selected/playing song indicator.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 20.0),
                _currentlySelectedSongIndex == index
                    ? Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Icon(
                          Icons.bar_chart,
                          color: Colors.red,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.black,
                        ),
                      )
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Widget displaying a search bar, including the search icon.
  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 9,
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Search artist',
                suffixIcon: _searchTerm != ''
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _controller.clear();
                            _searchTerm = '';
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (enteredText) {
                _searchTerm = enteredText;
                setState(() {});
              },
              onSubmitted: (_searchTerm) async {
                await search(_searchTerm);
              },
            ),
          ),
          Expanded(
              flex: 1,
              child: IconButton(
                icon: Icon(Icons.search),
                onPressed: () async {
                  // Closing the any virtual keyboard.
                  FocusScope.of(context).requestFocus(FocusNode());

                  await search(_searchTerm);
                },
              )),
        ],
      ),
    );
  }

  /// Returns the usable screen size for the app taking the toolbar height into account.
  static Size _screenSize(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = max(
        0,
        MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top -
            kToolbarHeight);

    return Size(screenWidth, screenHeight);
  }

  /// Main area of the home screen that contains a list view, showing search results.
  Widget _searchResultsArea() {
    Size screenSize = _screenSize(context);

    return _songsList != null
        ? !_noResultsFound && !_isSearching
            ? ListView.builder(
                controller: _listViewController,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _songsList.length,
                itemBuilder: (BuildContext context, int index) {
                  return _resultItem(index);
                },
              )
            : _isSearching
                ? _loadingSpinner()
                : Center(
                    child: Text(
                      'No results found for your search.',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  )
        // Checking if a search is run when the songs list is still null
        // to show the spinner, this happens when the first search is run.
        : _isSearching
            ? _loadingSpinner()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Start a new search...',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  screenSize.aspectRatio < 1
                      ? Image.asset(
                          'assets/images/music_search.png',
                          width: 0.8 * screenSize.width,
                        )
                      : Image.asset(
                          'assets/images/music_search.png',
                          height: 0.4 * screenSize.height,
                        ),
                  SizedBox(height: 10),
                ],
              );
  }

  /// Widget containing playback controls, displayed when music is playing/selected.
  Widget _playbackControlsBar() {
    // Setting the _isPlaying flag based on different states of the audio player plugin.
    _audioPlayer.onPlayerStateChanged.listen((AudioPlayerState state) {
      if (state.toString() == 'AudioPlayerState.PAUSED') {
        _isPlaying = false;
      } else if (state.toString() == 'AudioPlayerState.PLAYING') {
        _isPlaying = true;
      } else {
        // In case song has been played all the way through the end.
        setState(() {
          _isPlaying = false;
        });
      }
    });

    return ExpandedSection(
      expand: _showMusicControlsBar,
      child: Container(
        color: Colors.grey.withOpacity(0.2),
        height: 130,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Play/pause, previous and next song controls section.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.skip_previous),
                  onPressed:
                      // Disables the button if it's the first song in the list.
                      _currentlySelectedSongIndex != null &&
                              _currentlySelectedSongIndex > 0
                          ? playPreviousSong
                          : null,
                ),
                _isPlaying == true
                    ? IconButton(
                        icon: Icon(Icons.pause),
                        onPressed: () async {
                          await _audioPlayer.pause();
                          _isPlaying = false;
                          setState(() {});
                        },
                      )
                    : IconButton(
                        icon: Icon(Icons.play_arrow),
                        onPressed: () async {
                          await _audioPlayer.resume();
                          _isPlaying = true;
                          setState(() {});
                        },
                      ),
                IconButton(
                  icon: Icon(Icons.skip_next),
                  // Disables the button if it's the last song in the list.
                  onPressed: _currentlySelectedSongIndex != null &&
                          _currentlySelectedSongIndex < _songsList.length - 1
                      ? playNextSong
                      : null,
                ),
              ],
            ),

            // Volume slider section.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: IconButton(
                    icon: Icon(Icons.volume_down),
                    onPressed: null,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Slider(
                    value: _currentVolume,
                    min: 0.0,
                    max: 1.0,
                    onChanged: (double value) {
                      _audioPlayer.setVolume(value);
                      setState(
                        () {
                          _currentVolume = value;
                        },
                      );
                    },
                  ),
                ),
                Expanded(
                  child: IconButton(
                    icon: Icon(Icons.volume_up),
                    onPressed: null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Player'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _searchBar(),
          Expanded(
            child: _searchResultsArea(),
          ),
          _playbackControlsBar(),
        ],
      ),
    );
  }
}
# Music Player

A simple music player app created in Flutter that allows users to search Apple Itunes library for songs, based on any artist name.

## Supported devices

- The app can be run on both iOS and Android platforms, although at the current stage it has only been tested on Android. 
- The app supports Android devices running __Android Marshmallow (6.0)__ or newer.
- Testing at the current stage has been done on __Pixel 3a Emulator__.

## Supported Features

* Search the Apple Itunes library for songs, based on any artist name
* Navigate a list or results, containing track name, artist name, album name and album artwork
* Play a 30-second preview for each result
* Use music controls including play, pause, next/previous track buttons and a volume adjustment slider

## Features in action

<img src="./assets/images/music_player.gif" alt="drawing" width="350"/>

## Requirements to build

* Flutter SDK (version 2.0.3 or newer) and its requirements as explained in the link below:

```
https://flutter.dev/docs/get-started/install
```

## Instructions to build

**Step 0:**

Install Flutter SDK though the link below:

```
https://flutter.dev/docs/get-started/install
```

**Step 1:**

Download/clone the repo (extract if needed):

**Step 2:**

Navigate to project root and execute the following command in console to retrieve the required dependencies:

```
flutter pub get 
```

**Step 3:**

Run the app on an Android emulator/device (based on the [Supported Devices](#supported-devices))

## Instructions to deploy (for Android)

 Build/release as desired using the information provided in the link below:

```
https://flutter.dev/docs/deployment/android
```

### Packages used

* [http](https://pub.dev/packages/http)
* [audioplayers](https://pub.dev/packages/audioplayers)
* [flutter_spinkit](https://pub.dev/packages/flutter_spinkit)
* [bot_toast](https://pub.dev/packages/bot_toast)
* [mockito](https://pub.dev/packages/mockito/install)
* [build_runner](https://pub.dev/packages/build_runner)

### Folder Structure

```
lib/
|- models/
|- utils/
|- widgets/
|- generated_plugin_registrant.dart
|- home_screen.dart
|- main.dart
```

Brief explanation:

```
1 - models — To store different models as per project requirements, currently contains the core json model, along with a song model based on the format provided by the iTunes affiliate API.

2 - utils — To store utilities and functions of the app as needed, currently contains the iTunes API functions.

3 - widgets — To store common widgets for the app as needed to be reused, currently contains the 'expanded section' widget.

4 - generated_plugin_registrant.dart - Automatically generated file by the AudioPlayers package.

5 - home_screen.dart - Home screen of the app.

6 - main.dart - Starting point of the application.
```

### Other Notes

- I have not used state management in the current implementation, since the scale of the app is quite small and that would have only complicated things, unnecessarily. However, I would have used BloC if the project scale was larger and there was an actual benefit in the implementation.
- Just to clarify, I am using third party packages for loading spinner (flutter_spinkit) and snack bar (bot_toast). I am fully aware that Flutter has built-in widgets for these functionalities and the reason I am using those packages, is the fact that they give you much more customization options and having used them on previous projects, I was quite familiar with them.
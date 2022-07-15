import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NeumorphismProvider extends ChangeNotifier
{
  bool menu = false;
  bool prev = false;
  bool pause = false;
  bool next = false;

  setMenu()
  {
    menu = !menu;
    notifyListeners();
  }
  setPrev()
  {
    prev = !prev;
    notifyListeners();
  }
  setPause()
  {
    pause = !pause;
    notifyListeners();
  }
  setNext()
  {
    next = !next;
    notifyListeners();
  }

}

class ThemeProvider extends ChangeNotifier
{
  ThemeMode mode = ThemeMode.light;

  bool get isDark => mode == ThemeMode.light;

  Future<dynamic> themeSave(themeC,con) async
  {
    final sp = await SharedPreferences.getInstance();
    sp.setBool("themeValue", themeC);
    bool themeValue = sp.getBool("themeValue") ?? isDark;
    toggleTheme(themeValue, con);
  }

  toggleTheme(bool isLight,con)
  {
    mode = isLight ? ThemeMode.light : ThemeMode.dark;
    final barsTheme = SystemUiOverlayStyle
    (
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: isLight ? const Color(0xFFE4E4E0) : const Color(0xff292b2f),
      systemNavigationBarIconBrightness: isLight ? Brightness.dark : Brightness.light,
    );
    SystemChrome.setSystemUIOverlayStyle(barsTheme);
    notifyListeners();
  }
}

class MyThemes
{
  static final dark = ThemeData
  (
    scaffoldBackgroundColor: const Color(0xff292b2f),
    primaryColor: const Color(0xFFE4E4E0), //For icons
    colorScheme: const ColorScheme.light //Neumorphism shadows
    (
      primary: Colors.black87,
      secondary: Colors.white12,
    ),
  );

  static final light = ThemeData
  (
    scaffoldBackgroundColor: const Color(0xFFE4E4E0),
    primaryColor: const Color(0xff292b2f), //For icons
    colorScheme: const ColorScheme.dark
    (
      primary: Colors.grey,
      secondary: Colors.white,
    ),
  );
}

class MusicProvider extends ChangeNotifier
{
  final _audioQuery = OnAudioQuery();
  final _audioRoom = OnAudioRoom();

  List<SongModel>? songList;
  List<String> songNames = [];
  List<String> artistName = [];

  songFetchingFromAlbum(albumID) async
  {
    songNames = [];
    artistName = [];
    songList = await _audioQuery.queryAudiosFrom
    (
      AudiosFromType.ALBUM_ID,
      albumID,
      sortType: SongSortType.TITLE,
      orderType: OrderType.ASC_OR_SMALLER,
    );
    _songListAdding(songList);
  }
  _songListAdding(list)
  {
    for(var i=0;i<list!.length;i++)
    {
      songNames.add(list![i].title);
      artistName.add(list![i].artist.toString());
    }
    notifyListeners();
  }

  List<FavoritesEntity> favs = [];
  List<int> favIDList = [];

  bool favButton = false;

  setFavButton(id)
  {
    if(favButton == false)
    {
      _audioRoom.addTo(RoomType.FAVORITES,
      songList![id].getMap.toFavoritesEntity(),
      ignoreDuplicate: false);
      favFetching();
      print(favButton);
      print("fav ID: "+songList![id].id.toString());
    }
    if(favButton == true)
    {
      removeAtFavs(songList?[id].id ?? favs[id].id);
      favButton = false;
    }
    notifyListeners();
  }

  favFetching() async
  {
    favIDList = [];
    favs = await _audioRoom.queryFavorites();
    notifyListeners();
    for(var i=0;i<favs.length;i++)
    {
      favIDList.add(favs[i].id);
    }
  }

  favClear() async
  {
    await _audioRoom.clearRoom(RoomType.FAVORITES);
    favs = [];
    favIDList = [];
    notifyListeners();
  }

  removeAtFavs(i) async
  {
    await _audioRoom.deleteFrom(RoomType.FAVORITES,i);
    favFetching();
    notifyListeners();
  }

  int? index;

  setMusicName(indexID,i)
  {
    indexID = i;
    index = indexID;
    notifyListeners();
  }

  double sValue = 0;

  setSliderPos(n)
  {
    sValue = n;
    notifyListeners();
  }
}
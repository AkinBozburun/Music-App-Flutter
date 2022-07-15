import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:player/fav_list.dart';
import 'package:player/music_list.dart';
import 'package:player/providers.dart';
import 'package:player/widgets/theme_switch.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlbumsPage extends StatefulWidget
{
  const AlbumsPage({ Key? key }) : super(key: key);

  @override
  State<AlbumsPage> createState() => _AlbumsPageState();
}

class _AlbumsPageState extends State<AlbumsPage>
{
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<int> albumIDs = [];
  List<String> albumNames = [];
  List<String> albumArtists = [];
  List albumCovers = [];

  _handlePermission() async
  {
    bool permissionStatus = await _audioQuery.permissionsStatus();
    if (!permissionStatus)
    {
      await _audioQuery.permissionsRequest();
    }
    albumsFetching();
  }

  albumsFetching() async
  {
    List<AlbumModel> albumList = await _audioQuery.queryAlbums
    (
      sortType: AlbumSortType.ALBUM,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    for(var i = 0;i < albumList.length; i++)
    {
      setState(()
      {
        albumIDs.add(albumList[i].id);
        albumNames.add(albumList[i].album.toString());
        albumArtists.add(albumList[i].artist.toString());
        return albumCovers.add(
        QueryArtworkWidget
        (
          id: albumList[i].id,
          type: ArtworkType.ALBUM,
          artworkHeight: 500,
          artworkWidth: 500,
          artworkBorder: BorderRadius.circular(10),
        ));
      });
    }
    print("Album count: "+ albumIDs.length.toString());
  }

  _safetyGridBuilder()
  {
    Offset shadow = const Offset(3,3);

    if(albumIDs.isEmpty)
    {
      return Center
      (
        child: Column
        (
          mainAxisAlignment: MainAxisAlignment.center,
          children:
          [
            CircularProgressIndicator(color: Theme.of(context).primaryColor),
            const SizedBox(height: 40),
            Text("List is Might be Empty!", style: TextStyle(fontSize: 22.sp,color: Theme.of(context).primaryColor)),
          ],
        )
      );
    }
    else
    {
      return Center
      (
        child: GridView.builder
        (
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemCount: albumIDs.length,
          itemBuilder: (context, i) => GestureDetector
          (
            onTap: () =>
            Navigator.push(context, MaterialPageRoute
            (
              builder: (context) => MusicsPage(albumIDs[i], albumCovers[i], albumNames[i]),
            )),
            child: Container //Neumorphism Frame
            (
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration
              (
                color: Theme.of(context).scaffoldBackgroundColor ,borderRadius: BorderRadius.circular(10),
                boxShadow:
                [
                  BoxShadow
                  (
                    color: Theme.of(context).colorScheme.primary,
                    offset: shadow,
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                  BoxShadow
                  (
                    color: Theme.of(context).colorScheme.secondary,
                    offset: -shadow,
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ]
              ),
              child: Padding
              (
                padding: const EdgeInsets.all(3),
                child: Stack
                (
                  children:
                  [
                    albumCovers[i],
                    Align
                    (
                      alignment: Alignment.bottomCenter,
                      child: Container
                      (
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        alignment: Alignment.bottomCenter,
                        height: 60.sp,
                        decoration: const BoxDecoration
                        (
                          borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
                          color: Colors.black54
                        ),
                        child: Column
                        (
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children:
                          [
                            Text(albumNames[i],overflow: TextOverflow.ellipsis, style: GoogleFonts.roboto
                            (
                              textStyle: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w500, color: Colors.white),
                            )),
                            Text(albumArtists[i].toString(),overflow: TextOverflow.ellipsis, style: GoogleFonts.roboto
                            (
                              textStyle: TextStyle(fontSize: 18.sp, color: Colors.grey.shade400),
                            )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      );
    }
  }

  _themeReminder() async
  {
    final sp = await SharedPreferences.getInstance();
    bool themeValue = sp.getBool("themeValue") ?? true;
    final themeProvider = Provider.of<ThemeProvider>(context,listen: false);
    themeProvider.themeSave(themeValue, context);
  }

  _appbar() => AppBar
  (
    systemOverlayStyle: SystemUiOverlayStyle(statusBarIconBrightness: Theme.of(context).colorScheme.brightness),
    automaticallyImplyLeading: false,
    backgroundColor: Colors.transparent,
    elevation: 0,
    toolbarHeight: 100.sp,
    title: Text("Your Albums",style: GoogleFonts.workSans
    (
      textStyle: TextStyle(fontSize: 35.sp, fontWeight: FontWeight.w600, color: Theme.of(context).primaryColor),
    )),
    actions:
    [
      IconButton
      (
        onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> const FavList())),
        icon: Icon(Icons.favorite_rounded,size: 35.sp),
        color: Theme.of(context).primaryColor,
        iconSize: 35.sp,
      ),
      const ThemeSwitchButton(),
    ]
  );

  @override
  void initState()
  {
    _themeReminder();
    _handlePermission();
    Provider.of<MusicProvider>(context,listen: false).favFetching();
    super.initState();
  }

  @override
  Widget build(context)
  {
    return Scaffold
    (
      appBar: _appbar(),
      body: _safetyGridBuilder(),
    );
  }
}
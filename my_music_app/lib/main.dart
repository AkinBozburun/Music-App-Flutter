import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:on_audio_room/on_audio_room.dart';
import 'package:player/album_list.dart';
import 'package:player/providers.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async
{
  SystemChrome.setSystemUIOverlayStyle
  (
    const SystemUiOverlayStyle
    (
     statusBarColor: Colors.transparent,
    )
  );

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await OnAudioRoom().initRoom(RoomType.FAVORITES);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget
{
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return MultiProvider
    (
      providers:
      [
        ChangeNotifierProvider(create: (context)=> NeumorphismProvider()),
        ChangeNotifierProvider(create: (context)=> ThemeProvider()),
        ChangeNotifierProvider(create: (context)=> MusicProvider()),
      ],
      child: ScreenUtilInit
      (
        builder:(context, _)
        {
          final themeProvider = Provider.of<ThemeProvider>(context);
          return  MaterialApp
          (
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.mode,
            theme: MyThemes.light,
            darkTheme: MyThemes.dark,
            home: const AlbumsPage(),
          );
        },
        designSize: const Size(540, 912),
      ),
    );
  }
}
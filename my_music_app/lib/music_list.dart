import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:player/play_page.dart';
import 'package:player/providers.dart';
import 'package:provider/provider.dart';

class MusicsPage extends StatefulWidget
{
  var gelenCover;
  var gelenAlbumID;
  var gelenAlbumName;

  MusicsPage(this.gelenAlbumID, this.gelenCover, this.gelenAlbumName);

  @override
  State<MusicsPage> createState() => _MusicsPageState();
}

class _MusicsPageState extends State<MusicsPage>
{
  _songListing()
  {
    Color darkTextColor = Theme.of(context).primaryColor;
    Color neumorphism1 = Theme.of(context).colorScheme.primary;
    Color neumorphism2 = Theme.of(context).colorScheme.secondary;
    Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    Offset shadow = const Offset(3,3);

    final provider = Provider.of<MusicProvider>(context);

    if(provider.songNames.isEmpty)
    {
      return const Center(child: CircularProgressIndicator());
    }
    else
    {
      return SafeArea
      (
        child: Column
        (
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:
          [
            Container //Album Kapağı
            (
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration
              (
                borderRadius: BorderRadius.circular(30),
                color: backgroundColor,
                boxShadow:
                [
                  BoxShadow
                  (
                    color: neumorphism1,
                    offset: shadow,
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                  BoxShadow
                  (
                    color: neumorphism2,
                    offset: -shadow,
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ],
              ),
              height: 280.h,
              width: 280.w,
              child: ClipRRect
              (
                borderRadius: BorderRadius.circular(28),
                child: widget.gelenCover
              ),
            ),
            Text(widget.gelenAlbumName, style: GoogleFonts.roboto(fontSize: 28.sp,color: darkTextColor, fontWeight: FontWeight.w600)),
            Container //Şarkı Listesi
            (
              height: 400.h,
              margin: const EdgeInsets.symmetric(horizontal:30),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration
              (
                borderRadius: BorderRadius.circular(30),
                color: backgroundColor,
                boxShadow:
                [
                  BoxShadow
                  (
                    color: neumorphism1,
                    offset: shadow,
                    blurRadius: 5,
                    spreadRadius: 2,
                    inset: true,
                  ),
                  BoxShadow
                  (
                    color: neumorphism2,
                    offset: -shadow,
                    blurRadius: 5,
                    spreadRadius: 2,
                    inset: true,
                  ),
                ],
              ),
              child: ListView.builder
              (
                padding: EdgeInsets.zero,
                itemCount: provider.songList!.length,
                itemBuilder: (context, i) => ListTile
                (
                  onTap: ()
                  {
                    provider.index = null;
                    provider.setSliderPos(0.0);
                    Navigator.push(context, MaterialPageRoute
                    (
                      builder: (context) => PlayPage(widget.gelenCover, i, widget.gelenAlbumName, provider.songNames, provider.artistName),
                    ));
                  },
                  title: Text(provider.songNames[i],style: GoogleFonts.roboto(textStyle: TextStyle(color: darkTextColor), fontWeight: FontWeight.w500,fontSize: 22.sp)),
                  subtitle: Text(provider.artistName[i], style: GoogleFonts.roboto(textStyle: TextStyle(color: darkTextColor), fontSize: 20.sp)),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState()
  {
    Provider.of<MusicProvider>(context,listen: false).songFetchingFromAlbum(widget.gelenAlbumID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold
  (
    body: _songListing(),
  );
}
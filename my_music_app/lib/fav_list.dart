import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:player/play_page.dart';
import 'package:player/providers.dart';
import 'package:provider/provider.dart';

class FavList extends StatefulWidget
{
  const FavList({Key? key}) : super(key: key);

  @override
  State<FavList> createState() => _FavListState();
}

class _FavListState extends State<FavList>
{
  _appbar()
  {
    final provider = Provider.of<MusicProvider>(context);
    return AppBar
    (
      systemOverlayStyle: SystemUiOverlayStyle(statusBarIconBrightness: Theme.of(context).colorScheme.brightness),
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 100.sp,
      title: Text("Your Favourites",style: GoogleFonts.workSans
      (
        textStyle: TextStyle(fontSize: 35.sp, fontWeight: FontWeight.w600, color: Theme.of(context).primaryColor),
      )),
      actions:
      [
        IconButton //Delete Whole List!
        (
          onPressed: ()
          {
            provider.favClear();
          },
          icon: Icon(Icons.delete_rounded,size: 35.sp),
          color: Theme.of(context).primaryColor,
          iconSize: 35.sp,
        ),
      ],
    );
  }

  _favList()
  {
    Color backGroundColor = Theme.of(context).scaffoldBackgroundColor;
    Color n1 = Theme.of(context).colorScheme.primary;
    Color n2 = Theme.of(context).colorScheme.secondary;
    Offset shadow = const Offset(3,3);

    final provider = Provider.of<MusicProvider>(context);
    Color textColor = Theme.of(context).primaryColor;

    provider.songList = null;

    if(provider.favIDList.isEmpty)
    {
      return Center(child: Text("List is Empty!",style: TextStyle(color: textColor,fontSize: 22.sp,fontWeight: FontWeight.w600)));
    }
    else
    {
      return Center
      (
        child: ListView.builder
        (
          itemCount: provider.favs.length,
          itemBuilder: (context,i) => AnimatedContainer
          (
            margin: const EdgeInsets.all(10),
            height: 100.h,
            decoration: BoxDecoration
            (
              borderRadius: BorderRadius.circular(10),
              color: backGroundColor,
              boxShadow:
              [
                BoxShadow
                (
                  color: n1,
                  offset: shadow,
                  blurRadius: 10,
                ),
                BoxShadow
                (
                  color: n2,
                  offset: -shadow,
                  blurRadius: 10,
                ),
              ],
            ),
            duration: const Duration(milliseconds: 80),
            child: ListTile
            (
              onTap:()
              {
                Navigator.push(context, MaterialPageRoute(builder: (context) => PlayPage(null, i, "", null, null)));
              },
              leading: QueryArtworkWidget(id: provider.favs[i].id, type: ArtworkType.AUDIO,artworkBorder: BorderRadius.circular(10)),
              title: Text(provider.favs[i].title,style: TextStyle(color: textColor,fontSize: 22.sp,fontWeight: FontWeight.w500)),
              subtitle: Text(provider.favs[i].artist.toString(),style: TextStyle(color: textColor,fontSize: 20.sp)),
              trailing: IconButton
              (
                onPressed: () => provider.removeAtFavs(provider.favIDList[i]),
                icon: FaIcon(FontAwesomeIcons.xmark,color: textColor,size: 30.sp),
              ),
            ),
          ),
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold
  (
    appBar: _appbar(),
    body: _favList(),
  );
}
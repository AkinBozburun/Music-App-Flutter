import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:player/album_list.dart';
import 'package:player/providers.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlayPage extends StatefulWidget
{
  QueryArtworkWidget? gelenPhoto;
  int gelenListID;
  String gelenAlbum;

  List? gelenSongsList;
  List? gelenArtistsList;

  PlayPage(this.gelenPhoto,this.gelenListID ,this.gelenAlbum, this.gelenSongsList, this.gelenArtistsList, {Key? key}) : super(key: key);

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage>
{
  final pageController = CarouselController();

  _appbar(darkTextColor,backGroundColor,n1,n2,value,provider) => AppBar
  (
    systemOverlayStyle: SystemUiOverlayStyle(statusBarIconBrightness: Theme.of(context).colorScheme.brightness),
    automaticallyImplyLeading: false,
    backgroundColor: Colors.transparent,
    elevation: 0,
    toolbarHeight: 100.h,
    centerTitle: true,
    title: Row
    (
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:
      [
        _favButton(darkTextColor, backGroundColor,n1,n2,provider),
        Text(value.pause == true ? "Stopped" : "Playing",style: GoogleFonts.roboto(textStyle: TextStyle(color: darkTextColor), fontSize: 28.sp, fontWeight: FontWeight.w600)),
        _albumsButton(darkTextColor,backGroundColor,n1,n2,value),
      ],
    ),
  );

  _albumsButton(darkTextC,backGroundC,n1,n2,value)
  {
    Offset shadow = const Offset(3,3);
    return Listener
    (
      onPointerDown: (_) => value.setMenu(),
      onPointerUp: (_)
      {
        value.setMenu();
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute
        (
          builder: (context) => const AlbumsPage(),
        ),(route) => false);
      },
      child: AnimatedContainer
      (
        child: Icon(Icons.menu, color: darkTextC,size: 32.sp),
        height: 70.h,
        width: 70.h,
        duration: const Duration(milliseconds: 80),
        decoration: BoxDecoration
        (
          shape: BoxShape.circle,
          color: backGroundC,
          boxShadow:
          [
            BoxShadow
            (
              color: n1,
              offset: shadow,
              blurRadius: 6,
              spreadRadius: 1,
              inset: value.menu,
            ),
            BoxShadow
            (
              color: n2,
              offset: -shadow,
              blurRadius: 6,
              spreadRadius: 1,
              inset: value.menu,
            ),
          ]
        ),
      ),
    );
  }

  _favButton(darkTextC,backGroundC,n1,n2,provider)
  {
    Offset shadow = const Offset(2,2);

    if(provider.favIDList.contains(widget.gelenSongsList == null ? provider.favs[widget.gelenListID].id :provider.songList![widget.gelenListID].id))
    {
      provider.favButton = true;
    }
    else
    {
      provider.favButton = false;
    }
    return GestureDetector
    (
      onTap: () async
      {
        if
        (
          widget.gelenArtistsList == null && provider.favIDList.length == 1 ||
          widget.gelenArtistsList == null && widget.gelenListID == provider.favs.length-1
        )
        {
          Navigator.pop(context);
        }
        else
        {
          provider.setFavButton(widget.gelenListID);
        }
      },
      child: AnimatedContainer
      (
        child: Icon(provider.favButton == true ? Icons.favorite : Icons.favorite_border_rounded, color: darkTextC,size: 32.sp),
        height: 70.h,
        width: 70.h,
        duration: const Duration(milliseconds: 80),
        decoration: BoxDecoration
        (
          shape: BoxShape.circle,
          color: backGroundC,
          boxShadow:
          [
            BoxShadow
            (
              color: n1,
              offset: shadow,
              blurRadius: 6,
              spreadRadius: 1,
              inset: provider.favButton,
            ),
            BoxShadow
            (
              color: n2,
              offset: -shadow,
              blurRadius: 6,
              spreadRadius: 1,
              inset: provider.favButton,
            ),
          ]
        ),
    ),
    );
  }

  _carouselPass(backGroundC,darkTextC,controller,n1,n2,provider)
  {
    return CarouselSlider.builder
    (
      carouselController: controller,
      itemCount: widget.gelenSongsList == null ? provider.favs.length : widget.gelenSongsList?.length,
      itemBuilder: (context,i,index) => _albumPhoto(backGroundC,darkTextC,n1,n2,provider,i),
      options: CarouselOptions
      (
        initialPage: widget.gelenListID,
        height: 430.h,
        enlargeCenterPage: true,
        enableInfiniteScroll: false,
        onPageChanged: (i,reason)
        {
          provider.setSliderPos(0.0);
          provider.setMusicName(widget.gelenListID, i);
          widget.gelenListID = i;

        },
      )
    );
  }

  _albumPhoto(backGroundC,darkTextC,n1,n2,provider,i)
  {
    Offset shadow = const Offset(3,3);
    return Container
    (
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.symmetric(vertical: 20),
      height: 400.h,
      width: 400.w,
      decoration: BoxDecoration
      (
        borderRadius: BorderRadius.circular(30),
        color: backGroundC,
        boxShadow:
        [
          BoxShadow
          (
            color: n1,
            offset: shadow,
            blurRadius: 10,
            spreadRadius: 2,
          ),
          BoxShadow
          (
            color: n2,
            offset: -shadow,
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect
      (
        borderRadius: BorderRadius.circular(25),
        child: widget.gelenPhoto ?? QueryArtworkWidget(id: provider.favs[i].id, type: ArtworkType.AUDIO,
        artworkBorder: BorderRadius.circular(0)),
      ),
    );
  }

  _playSlider(darkTextC,backGroundC,n1,n2,provider) => SizedBox
  (
    height: 5,
    child: Slider
    (
      value: provider.sValue ?? 10.0,
      min: 0.0,
      max: 100.0,
      thumbColor: darkTextC,
      activeColor: n1,
      inactiveColor: n2,
      onChanged: (n)
      {
        provider.setSliderPos(n);
      },
    ),
  );

  _albumSongName(provider,darkTextC)
  {
    return SizedBox
    (
      width: 450.w,
      child: ListTile
      (
        onTap: ()=> Navigator.pop(context),
        title: Center
        (
          child: Text
          (
            widget.gelenSongsList?[provider.index ?? widget.gelenListID] ?? provider.favs[widget.gelenListID].title,
            style: GoogleFonts.roboto
            (
              textStyle: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w700, color: darkTextC)
            ),
            textAlign: TextAlign.center,
          ),
        ),
        subtitle: Center
        (
          child: Text(widget.gelenArtistsList?[provider.index ?? widget.gelenListID] ?? provider.favs[widget.gelenListID].artist.toString(), style: GoogleFonts.roboto
          (
            textStyle: TextStyle(color: darkTextC, fontSize: 26.sp,),
          )),
        ),
      ),
    );
  }

  _preSong(darkTextC,backGroundC,controller,n1,n2,value,provider)
  {
    Offset shadow = const Offset(4,4);
    return Listener
    (
      onPointerUp: (_) => value.setPrev(),
      onPointerDown: (_)
      {
        value.setPrev();
        if(provider.sValue > 10)
        {
          provider.setSliderPos(0.0);
        }
        else
        {
          controller.previousPage();
        }
      },
      child: AnimatedContainer
      (
        child: Icon(Icons.skip_previous_rounded,size: 45.sp,color: darkTextC),
        duration: const Duration(milliseconds: 80),
        height: 90.h,
        width: 90.h,
        decoration: BoxDecoration
        (
          shape: BoxShape.circle,
          color: backGroundC,
          boxShadow:
          [
            BoxShadow
            (
              color: n1,
              offset: shadow,
              blurRadius: 10,
              spreadRadius: 1,
              inset: value.prev,
            ),
            BoxShadow
            (
              color: n2,
              offset: -shadow,
              blurRadius: 10,
              spreadRadius: 1,
              inset: value.prev,
            ),
          ]
        ),
      ),
    );
  }

  _pauseSong(darkTextC,backGroundC,n1,n2,value)
  {
    Offset shadow = const Offset(4,4);
    return GestureDetector
    (
      onTap: () => value.setPause(),
      child: AnimatedContainer
      (
        child: value.pause ? Icon(Icons.play_arrow_rounded,size: 55.sp,color: darkTextC,):
        Icon(Icons.pause_rounded,size: 55.sp,color: darkTextC),
        duration: const Duration(milliseconds: 80),
        height: 110.h,
        width: 110.h,
        decoration: BoxDecoration
        (
          shape: BoxShape.circle,
          color: backGroundC,
          boxShadow:
          [
            BoxShadow
            (
              color: n1,
              offset: shadow,
              blurRadius: 10,
              spreadRadius: 1,
              inset: value.pause,
            ),
            BoxShadow
            (
              color: n2,
              offset: -shadow,
              blurRadius: 10,
              spreadRadius: 1,
              inset: value.pause,
            ),
          ]
        ),
      ),
    );
  }

  _nextSong(darkTextC,backGroundC,n1,n2,value)
  {
    Offset shadow = const Offset(4,4);
    return Listener
    (
      onPointerUp: (_) => value.setNext(),
      onPointerDown: (_)
      {
        value.setNext();
        pageController.nextPage();
      },
      child: AnimatedContainer
      (
        child: Icon(Icons.skip_next_rounded, size: 45.sp,color: darkTextC),
        duration: const Duration(milliseconds: 80),
        height: 90.h,
        width: 90.h,
        decoration: BoxDecoration
        (
          shape: BoxShape.circle,
          color: backGroundC,
          boxShadow:
          [
            BoxShadow
            (
              color: n1,
              offset: shadow,
              blurRadius: 10,
              spreadRadius: 1,
              inset: value.next,
            ),
            BoxShadow
            (
              color: n2,
              offset: -shadow,
              blurRadius: 10,
              spreadRadius: 1,
              inset: value.next,
            ),
          ]
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context)
  {
    final provider = Provider.of<MusicProvider>(context);
    final value = Provider.of<NeumorphismProvider>(context);

    Color backGroundColor = Theme.of(context).scaffoldBackgroundColor;
    Color darkTextColor = Theme.of(context).primaryColor;
    Color neumorphism1 = Theme.of(context).colorScheme.primary;
    Color neumorphism2 = Theme.of(context).colorScheme.secondary;

    return Scaffold
    (
      appBar: _appbar(darkTextColor, backGroundColor ,neumorphism1, neumorphism2,value,provider),
      body: Column
      (
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:
        [
          _carouselPass(backGroundColor,darkTextColor,pageController,neumorphism1,neumorphism2,provider),
          _albumSongName(provider,darkTextColor),
          _playSlider(darkTextColor,backGroundColor,neumorphism1,neumorphism2,provider),
          Row
          (
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:
            [
              _preSong(darkTextColor, backGroundColor,pageController,neumorphism1,neumorphism2,value,provider),
              _pauseSong(darkTextColor, backGroundColor,neumorphism1,neumorphism2,value),
              _nextSong(darkTextColor, backGroundColor,neumorphism1,neumorphism2,value),
            ],
          ),
        ],
      ),
    );
  }
}
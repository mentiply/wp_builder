import 'package:flutter/material.dart';
import '../../bloc/favBloc.dart';
import '../../models/postModel/post_model.dart';
import '../../ui/home/widgets/post_card.dart';


class Favouriteposts extends StatefulWidget {
  Favouriteposts({Key key}) : super(key: key);
  @override
  _FavouritepostsState createState() => _FavouritepostsState();
}

class _FavouritepostsState extends State<Favouriteposts> {
  final FavPostBloc favpostBloc = FavPostBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Favourite"),
        elevation: 5,
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(children: <Widget>[categoryPosts()])),
      ),
    );
  }

  Widget categoryPosts() {
    return FutureBuilder<List<PostModel>>(
      future: favpostBloc.getFavposts(),
      builder: (context, AsyncSnapshot<List<PostModel>> postsnapshot) {
        if (postsnapshot.hasData) {
          if (postsnapshot.data.length == 0) return Container();
          return Column(
              children: postsnapshot.data.map((item) {
            return PostCard(context, item);
          }).toList());
        } else if (postsnapshot.hasError) {
          return Container(
              height: 500,
              alignment: Alignment.center,
              child: Text("${postsnapshot.error}"));
        }
        return Container(
          alignment: Alignment.center,
          height: 400,
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

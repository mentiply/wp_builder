import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../../bloc/favBloc.dart';
import '../../models/postModel/post_model.dart';
import 'package:share/share.dart';

class DetailScreen extends StatefulWidget {
  String _heroId;
  PostModel _post;

  DetailScreen(this._heroId,this._post);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final FavPostBloc favpostBloc = FavPostBloc();

  Future<dynamic> favpost;

  @override
  void initState() {
    super.initState();
    favpost = favpostBloc.getFavPost(widget._post.id);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            Stack(
              children: <Widget>[
                Container(
                  child: Hero(
                    tag: widget._heroId,
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(60.0)),
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.3), BlendMode.overlay),
                        child: CachedNetworkImage(
                          imageUrl: widget._post.jetpack_featured_media_url,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Center(child: Icon(Icons.error),),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
            ListTile(
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FutureBuilder<dynamic>(
                      future: favpost,
                      builder:
                          (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            decoration: BoxDecoration(),
                            child: IconButton(
                              padding: EdgeInsets.all(0),
                              icon: Icon(
                                Icons.favorite,
                                color: Colors.red,
                                size: 24.0,
                              ),
                              onPressed: () {
                                // Favourite post
                                favpostBloc.deleteFavPostById(widget._post.id);
                                setState(() {
                                  favpost =
                                      favpostBloc.getFavPost(widget._post.id);
                                });
                              },
                            ),
                          );
                        }
                        return Container(
                          decoration: BoxDecoration(),
                          child: IconButton(
                            padding: EdgeInsets.all(0),
                            icon: Icon(
                              Icons.favorite_border,
                              color: Colors.red,
                              size: 24.0,
                            ),
                            onPressed: () {
                              favpostBloc.addFavPost(widget._post);
                              setState(() {
                                favpost =
                                    favpostBloc.getFavPost(widget._post.id);
                              });
                            },
                          ),
                        );
                      }),
                  IconButton(icon: Icon(Icons.share, color: Colors.green,),
                    onPressed: (){
                      Share.share(widget._post.link);
                    },
                  ),
                ],
              ),
              title: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Html(
                  data: widget._post.title,
                  defaultTextStyle: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              subtitle: Container(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(4, 8, 4, 8),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.timer,
                            color: Colors.black45,
                            size: 12.0,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            widget._post.date,
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(16, 10, 16, 50),
              child: HtmlWidget(
                widget._post.content,
                webView: true,
                textStyle: TextStyle(fontSize: 16)

              ),
            ),
          ],
        ),
      ),
    );
  }
}

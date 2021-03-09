import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../models/postModel/post_model.dart';
import '../../../ui/home/detail_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget PostCard(BuildContext context, PostModel post) {
  final heroId = post.id.toString() + UniqueKey().toString();
  return InkWell(
    onTap: () {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => DetailScreen(heroId, post),
      ));
    },
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Hero(
            tag: heroId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: CachedNetworkImage(
                imageUrl: post.jetpack_featured_media_url,
                height: 150,
                width: 150,
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Center(child: Icon(Icons.error),),
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Html(
                    data: post.title,
                    defaultTextStyle:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Html(
                          data: '${post.content.substring(0, 60)}....',
                          defaultTextStyle: TextStyle(fontSize: 15),
                          useRichText: true,
                        ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.timer,
                        color: Colors.black45,
                        size: 15.0,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        post.date,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class More extends StatefulWidget {
  More(this.name, this.about);
  String name;
  String about;

  @override
  _MoreState createState() => _MoreState();
}

class _MoreState extends State<More> {
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('More'),
      ),
      body: ListView(
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 30.0),
            leading: FaIcon(
              FontAwesomeIcons.addressCard,
              color: Colors.indigo,
            ),
            title: Text('About Us'),
            subtitle: Text(widget.about),
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 30.0),
            leading: Icon(
              Icons.people,
              color: Colors.blue,
            ),
            title: Text('Presented By'),
            subtitle: Text(widget.name),
          ),
          ListTile(
            onTap: () {
              _launchURL(
                  '');
            },
            contentPadding: EdgeInsets.symmetric(horizontal: 30.0),
            leading: FaIcon(
              FontAwesomeIcons.appStore,
              color: Colors.red,
            ),
            title: Text('Develop With'),
            subtitle: Text('WordPress App Builder'),
          ),
        ],
      ),
    );
  }
}
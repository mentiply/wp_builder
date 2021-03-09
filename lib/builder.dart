import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/latestPostBloc/get_latest_post_cubit.dart';
import 'services/locator.dart';
import 'ui/category/category_screen.dart';
import 'ui/favourite/favoutite_screen.dart';
import 'ui/home/home_screen.dart';
import 'ui/more/more_screen.dart';

import 'bloc/categoryBloc/get_category_cubit.dart';


class MyApp extends StatelessWidget {
  final String link;
  final String name;
  final String about;

  MyApp(this.link, this.name, this.about);

  @override
  Widget build(BuildContext context) {
    String checkWeb = link.characters.last == '/'?link: link+'/';
    String url = 'https://public-api.wordpress.com/wp/v2/sites/'+checkWeb;
    locator(url);
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetLatestPostCubit>(
          create: (_) => getIt.call(),
        ),
        BlocProvider<GetCategoryCubit>(
          create: (_) => getIt.call(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.indigo,
          scaffoldBackgroundColor: Colors.white
        ),
        home: LandingScreen(name, about),
        debugShowCheckedModeBanner: false,
        title: name,
      ),
    );
  }
}

class LandingScreen extends StatefulWidget {
  LandingScreen(this.name, this.about);
  String name;
  String about;

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> _children = [
      HomeScreen(),
      CategoryScreen(),
      Favouriteposts(),
      More(widget.name, widget.about),
    ];

    return Scaffold(
      body: _children[index],
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.blue,
        onTap: (i) {
          setState(() {
            index = i;
          });
        },
        currentIndex: index,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.filter_list), label: 'Category'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favourite'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'More'),
        ],
      ),
    );
  }
}

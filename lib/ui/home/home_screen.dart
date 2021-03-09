import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/latestPostBloc/get_latest_post_cubit.dart';
import '../../models/postModel/post_model.dart';
import '../../services/locator.dart';
import '../../ui/home/detail_screen.dart';
import '../../ui/home/search_screen.dart';
import '../../ui/home/widgets/post_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController _controller;
  int page = 1;
  bool _infiniteStop;

  // List<PostModel> postList;

  _scrollListener() {
    var isEnd = _controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange;
    if (isEnd) {
      setState(() {
        page += 1;
        BlocProvider.of<GetLatestPostCubit>(context, listen: false)
            .getLatestPost(page);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _controller =
        ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
    _controller.addListener(_scrollListener);
    _infiniteStop = false;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<PostModel> postList =
        BlocProvider.of<GetLatestPostCubit>(context, listen: false)
            .getAllPost();
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<GetLatestPostCubit, GetLatestPostState>(
          listener: (context, state) {
            if (state is GetLatestPostSuccess) {
              setState(() {
                _infiniteStop = false;
              });
            } else if (state is GetLatestPostLoading) {
              setState(() {
                _infiniteStop = true;
              });
            }
          },
          builder: (context, state) {
            if (state is GetLatestPostLoading && postList.length == 0) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is GetLatestPostFail) {
              return Center(
                child: Text(state.error),
              );
            } else {
              return SingleChildScrollView(
                controller: _controller,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextFormField(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchScreen(),
                              ));
                        },
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: 'Search',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          suffixIcon: IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SearchScreen(),
                                    ));
                              }),
                        ),
                      ),
                    ),
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 300.0,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.ease,
                        enlargeCenterPage: true,
                      ),
                      items: postList.map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return InkWell(
                              onTap: () {
                                final heroId =
                                    i.id.toString() + UniqueKey().toString();
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => DetailScreen(heroId, i),
                                ));
                              },
                              child: Container(
                                  width: MediaQuery.of(context).size.width *1,
                                  //margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  child: CachedNetworkImage(
                                    width: MediaQuery.of(context).size.width *1,
                                    imageUrl: i.jetpack_featured_media_url,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) => Center(child: Icon(Icons.error),),
                                  )),
                            );
                          },
                        );
                      }).toList(),
                    ),
                    Divider(
                      indent: 20,
                      endIndent: 20,
                      height: 30,
                      color: Colors.black,
                    ),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: postList.length,
                      itemBuilder: (context, index) =>
                          PostCard(context, postList[index]),
                    ),
                    Container(
                      child: Center(
                        child: LinearProgressIndicator(),
                      ),
                      height: _infiniteStop ? 20 : 0,
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

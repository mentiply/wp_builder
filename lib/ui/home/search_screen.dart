import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/latestPostBloc/get_latest_post_cubit.dart';
import '../../models/postModel/post_model.dart';
import '../../ui/home/widgets/post_card.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  ScrollController _controller;
  int page = 1;
  bool _infiniteStop;
  String searchText='';
  bool searching = false;
  // List<PostModel> postList;

  _scrollListener() {
    var isEnd = _controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange;
    if (isEnd) {
      setState(() {
        page += 1;
        BlocProvider.of<GetLatestPostCubit>(context, listen: false)
            .searchPost(searchText, page);
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

  void search(){
    setState(() {
      page =1;
      searching = true;
    });
    BlocProvider.of<GetLatestPostCubit>(context, listen: false)
        .searchPost(searchText, page);
  }


  @override
  Widget build(BuildContext context) {
    List<PostModel> postList = BlocProvider.of<GetLatestPostCubit>(context, listen: false).getAllSearchList();

    return Scaffold(
      appBar: AppBar(title: Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Type name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (text){
                  searchText = text;
                },
                onFieldSubmitted: (text) {
                  search();
                },
                autofocus: true,
              ),
            ),
            Expanded(
              child: BlocConsumer<GetLatestPostCubit, GetLatestPostState>(
                listener: (context, state) {
                  if (state is GetLatestPostSuccess) {
                    setState(() {
                      _infiniteStop = false;
                      searching = false;
                    });
                  } else if (state is GetLatestPostLoading) {
                    setState(() {
                      _infiniteStop = true;
                    });
                  }
                },
                builder: (context, state) {
                  if (state is GetLatestPostLoading && postList.length == 0 && searching) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is GetLatestPostFail) {
                    return Center(
                      child: Text(state.error),
                    );
                  } else {
                    return Column(
                      children: [
                        Expanded(
                          child: Scrollbar(
                            child: ListView.builder(
                              controller: _controller,
                              itemCount: postList.length,
                              itemBuilder: (context, index) =>
                                  PostCard(context, postList[index]),
                            ),
                          ),
                        ),
                        Container(
                          child: Center(
                            child: LinearProgressIndicator(),
                          ),
                          height: _infiniteStop ? 20 : 0,
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

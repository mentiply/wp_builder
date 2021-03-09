import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/latestPostBloc/get_latest_post_cubit.dart';
import '../../models/postModel/post_model.dart';
import '../../services/locator.dart';
import '../../ui/home/widgets/post_card.dart';

class FilterScreen extends StatefulWidget {
  final int id;
  final String categoryName;
  final String desc;

  FilterScreen(this.id, this.categoryName, this.desc);

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
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
            .getPostByCategory(widget.id, page);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetLatestPostCubit>(context, listen: false)
        .getPostByCategory(widget.id, page);
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
    List<PostModel> postList = BlocProvider.of<GetLatestPostCubit>(
        context, listen: false).getAllFilterPost();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
      ),
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
            return Column(
              children: [
                widget.desc == null || widget.desc == ''
                    ? Container()
                    : Container(
                  padding: EdgeInsets.all(10.0),
                    child: Text(widget.desc)),
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
    );
  }
}

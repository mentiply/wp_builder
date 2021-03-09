import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/categoryBloc/get_category_cubit.dart';
import '../../models/categoryModel/category_model.dart';
import '../../services/locator.dart';
import '../../ui/category/widgets/category_card.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  ScrollController _controller;

  int page = 1;

  bool _infiniteStop;

  _scrollListener() {
    var isEnd = _controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange;
    if (isEnd) {
      setState(() {
        page += 1;
        BlocProvider.of<GetCategoryCubit>(context, listen: false)
            .getCategory(page);
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
    List<CategoryModel> category =
        BlocProvider.of<GetCategoryCubit>(context, listen: false)
            .getAllCategory();

    return Scaffold(
      appBar: AppBar(
        title: Text('Category List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocConsumer<GetCategoryCubit, GetCategoryState>(
          listener: (context, state) {
            if (state is GetCategorySuccess) {
              setState(() {
                _infiniteStop = false;
              });
            } else if (state is GetCategoryLoading) {
              setState(() {
                _infiniteStop = true;
              });
            }
          },
          builder: (context, state) {
            if (state is GetCategoryLoading && category.length == 0) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is GetCategoryFail) {
              return Center(
                child: Text(state.error),
              );
            } else {
              return Column(
                children: [
                  Expanded(
                    child: Scrollbar(
                      child: ListView.separated(
                        separatorBuilder: (context, index) => Divider(
                          indent: 16,
                          endIndent: 16,
                        ),
                        controller: _controller,
                        itemCount: category.length,
                        itemBuilder: (context, index) =>
                            CategoryCard(context, category[index]),
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
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../models/categoryModel/category_model.dart';
import '../../../ui/category/filter_post.dart';
import 'package:random_color/random_color.dart';

Widget CategoryCard(BuildContext context, CategoryModel category) {
  RandomColor _randomColor = RandomColor();
  Color _color = _randomColor.randomColor(
    colorBrightness: ColorBrightness.primary,
  );

  Color _textColor = Colors.white;

  return ListTile(
    contentPadding: EdgeInsets.all(10.0),
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                FilterScreen(category.id, category.name, category.description),
          ));
    },
    title: Text(category.name),
    leading: CircleAvatar(child: Text(category.count.toString(), style: TextStyle(color: _textColor),), backgroundColor: _color),
    subtitle: Text(category.description),
  );
}

import 'package:aviz_project/settings/settings.dart';
import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  final dynamic _category;
  final double? margin;
  const CategoryButton(this._category, this.margin,{super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      margin: EdgeInsets.only(bottom: margin ?? 0.0),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        border: Border.all(color: ColorSetting.lightGrey, width: 2.0),
        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset('assets/images/red_arrow_left_icon.png'),
          Text(
            _category.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}

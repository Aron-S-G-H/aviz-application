import 'package:aviz_project/settings/settings.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

Widget detailScreenCustomHeader(
  BuildContext context,
  String title,
  Widget icon,
) {
  return Row(
    spacing: 8.0,
    children: [
      SizedBox(
        height: 24.0,
        width: 24.0,
        child: icon,
      ),
      Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    ],
  );
}

Widget customBox(
  BuildContext context,
  List<Map<String, String?>> items,
) {
  return Container(
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      border: Border.all(color: ColorSetting.lightGrey1),
      borderRadius: BorderRadius.circular(4.0),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: items.asMap().entries.map(
        (entry) {
          int index = entry.key;
          Map<String, String?> item = entry.value;

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item['title']!,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: ColorSetting.textGray),
                  ),
                  if (item['value'] != null)
                    Text(
                      item['value']!,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                ],
              ),
              if (index != items.length - 1)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: DottedLine(
                    dashColor: ColorSetting.lightGrey1,
                    lineThickness: 2.0,
                    dashLength: 4.0,
                    dashGapLength: 4.0,
                  ),
                ),
            ],
          );
        },
      ).toList(),
    ),
  );
}

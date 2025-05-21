import 'package:aviz_project/Utils/int_extention.dart';
import 'package:aviz_project/features/Aviz/data/model/aviz.dart';
import 'package:aviz_project/features/Aviz/pages/aviz_detail_screen.dart';
import 'package:aviz_project/settings/settings.dart';
import 'package:aviz_project/widgets/cached_network_image.dart';
import 'package:flutter/material.dart';

class HorizontalCart extends StatelessWidget {
  final Aviz aviz;
  const HorizontalCart(this.aviz, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AvizDetailScreen(aviz),
          ),
        );
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          height: 139.0,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            shadows: const [
              BoxShadow(
                color: Color.fromARGB(255, 218, 218, 218),
                blurRadius: 8.0, // soften the shadow
                spreadRadius: 5.0, //extend the shadow
                offset: Offset(0.0, 5.0),
              )
            ],
          ),
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 107.0,
                width: 220.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      aviz.title,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontSize: 14.0),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      aviz.description,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontSize: 12.0),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('قیمت: ',
                            style: Theme.of(context).textTheme.labelSmall),
                        Text(
                          aviz.price.priceFormat(),
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(color: ColorSetting.customRed),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 120.0,
                height: 107.0,
                child: cachedNetworkImage(aviz.images.first),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:aviz_project/components/horizontal_cart.dart';
import 'package:aviz_project/features/Aviz/data/model/aviz.dart';
import 'package:aviz_project/settings/settings.dart';
import 'package:flutter/material.dart';

class ListScreen extends StatelessWidget {
  final List<Aviz> avizes;
  final String title;
  const ListScreen(this.avizes, this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        centerTitle: true,
        title: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: ColorSetting.customRed),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.only(top: 32.0, right: 16.0, left: 16.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => HorizontalCart(avizes[index]),
                  childCount: avizes.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

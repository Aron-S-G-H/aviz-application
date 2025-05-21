part of 'aviz_detail_screen.dart';

class FeaturesScreen extends StatelessWidget {
  final List<String> facilities;
  const FeaturesScreen(this.facilities, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        detailScreenCustomHeader(
          context,
          'ویژگی ها',
          Image.asset('assets/images/property_icon.png'),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 24.0, bottom: 32.0),
          child: customBox(
            context,
            [
              {'title': 'سند', 'value': 'تک برگ'},
              {'title': 'جهت ساختمان', 'value': 'شمالی'},
            ],
          ),
        ),
        detailScreenCustomHeader(
          context,
          'امکانات',
          Image.asset('assets/images/facilities_icon.png'),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: customBox(
            context,
            facilities.map((item) => {'title': item}).toList(),
          ),
        ),
      ],
    );
  }
}

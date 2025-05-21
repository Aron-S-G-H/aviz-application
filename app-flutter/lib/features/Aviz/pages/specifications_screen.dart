part of 'aviz_detail_screen.dart';

class SpecificationsScreen extends StatelessWidget {
  final int totalArea;
  final int rooms;
  final int floor;
  final int yearOfConstruction;
  const SpecificationsScreen(
    this.totalArea,
    this.rooms,
    this.floor,
    this.yearOfConstruction, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> items = [
      {'title': 'متراژ', 'value': '$totalArea'},
      {'title': 'اتاق', 'value': '$rooms'},
      {'title': 'طبقه', 'value': '$floor'},
      {'title': 'سال ساخت', 'value': '$yearOfConstruction'},
    ];
    return Column(
      children: [
        Container(
          height: 98.0,
          decoration: BoxDecoration(
            border: Border.all(color: ColorSetting.lightGrey1),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Row(
            children: List.generate(items.length * 2 - 1, (index) {
              if (index.isEven) {
                final item = items[index ~/ 2];
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        item['title']!,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: ColorSetting.textGray),
                      ),
                      Text(
                        item['value']!,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 25.0),
                  child: DottedLine(
                    dashColor: ColorSetting.lightGrey1,
                    lineThickness: 2.0,
                    direction: Axis.vertical,
                  ),
                );
              }
            }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 32.0, bottom: 24.0),
          child: detailScreenCustomHeader(
            context,
            'موقعیت مکانی',
            Image.asset('assets/images/map_icon.png'),
          ),
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 144.0,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                image: DecorationImage(
                  image: AssetImage('assets/images/map.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            CustomElevatedButton(
              title: 'خیابان میرزای شیرازی',
              onActionTap: () {},
              size: const Size(185.0, 40.0),
              icon: Image.asset('assets/images/location_icon.png'),
              iconAlignment: IconAlignment.end,
            ),
          ],
        )
      ],
    );
  }
}

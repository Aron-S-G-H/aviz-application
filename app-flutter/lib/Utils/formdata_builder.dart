import 'package:dio/dio.dart';

Future<FormData> formDataBuilder(Map<String, dynamic> data) async {
  return FormData.fromMap({
    'category': data['categoryId'],
    'address': data['address'],
    'rooms': data['rooms'],
    'floor': data['floor'],
    'total_area': data['totalArea'],
    'price': data['price'],
    'description': data['description'],
    'year_of_construction': data['yearOfConstruction'],
    'facilities': data['facilities'],
    'is_location_allowed': data['isLocationAllowed'],
    'chat_available': data['chatAvailable'],
    'call_available': data['callAvailable'],
    'location': data['location'],
    'title': data['title'],
    'price_per_meter': data['pricePerMeter'],
    'images': await Future.wait(data['images'].map<Future<MultipartFile>>(
      (compressedImage) async => await MultipartFile.fromFile(
        compressedImage.path,
        filename: 'uploaded_image.jpg',
      ),
    )),
  });
}

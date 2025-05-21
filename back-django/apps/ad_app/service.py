from apps.ad_app.models import Aviz, AvizPoster


def create_aviz(data):
    try:
        aviz = Aviz.objects.create(
            category=data['category'],
            title=data['title'],
            description=data['description'],
            total_area=data['total_area'],
            rooms=data['rooms'],
            floor=data['floor'],
            year_of_construction=data['year_of_construction'],
            price=data['price'],
            price_per_meter=data['price_per_meter'],
            latitude=data['location']['latitude'],
            longitude=data['location']['longitude'],
            is_location_allowed=data['is_location_allowed'],
            chat_available=data['chat_available'],
            call_available=data['call_available'],
        )
        aviz.facilities.set(data['facilities'])
        for image in data['images']:
            AvizPoster.objects.create(aviz=aviz, poster=image)
    except Exception as e:
        print(e)

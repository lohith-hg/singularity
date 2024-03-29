import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../model/history_album.dart';
import '../model/mars_pictures.dart';
import '../model/picture_of_the_day.dart';

class LocalService {
  Future<List<PictureOfTheDay>?> getPictures(
      DateTime startDay, int days) async {
    var lastDate = startDay.subtract(Duration(days: days));
    var oldDate = "${lastDate.year}-${lastDate.month}-${lastDate.day}";
    var latestDate =
        "${startDay.subtract(const Duration(hours: 9)).year}-${startDay.subtract(const Duration(hours: 9)).month}-${startDay.subtract(const Duration(hours: 9)).day}";

    var client = http.Client();
    var uri = Uri.parse(
        'https://api.nasa.gov/planetary/apod?api_key=Ah79iXNawQ4pH4Yl9j29zLaf8fBMabbE1dB6GtvW&start_date=$oldDate&end_date=$latestDate');
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      var json = response.body;
      return pictureOfTheDayFromJson(json);
    }
  }

  Future<MarsPictures?> getMarsPictures() async {
    var latestDate =
        "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
    var client = http.Client();
    var uri = Uri.parse(
        'https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?earth_date=$latestDate&api_key=Ah79iXNawQ4pH4Yl9j29zLaf8fBMabbE1dB6GtvW');
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      var json = response.body;
      return marsPicturesFromJson(json);
    }
  }

  Future<List<HistoryAlbum>?> getHistoryAlbumPictures(
      String searchString) async {
    Random random = Random();
    int randomNumber1 = random.nextInt(10) + 1;
    print("printing random numbera");
    print(randomNumber1);
    var client = http.Client();
    var uri = Uri.parse(
        'https://images-api.nasa.gov/search?q=$searchString&page_size=5&page=$randomNumber1');
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      var json = response.body;
      var data = jsonDecode(json);
      var items = List<HistoryAlbum>.from(data['collection']['items']
          .map((data) => historyAlbumFromJson(jsonEncode(data))));
      return items;
    }
    return null;
  }
}
